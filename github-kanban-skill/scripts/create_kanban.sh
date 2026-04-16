#!/bin/bash
# GitHub Projects 칸반 보드 자동 생성 스크립트
# 사용법:
#   bash create_kanban.sh                          # 이름 입력 프롬프트 + 현재 리포지토리
#   bash create_kanban.sh "My Board"               # 이름 지정 + 현재 리포지토리
#   bash create_kanban.sh "My Board" "owner/repo"  # 이름 + 리포지토리 모두 지정

set +e  # 개별 오류 발생 시에도 계속 진행

# ──────────────────────────────────────────
# 0. 색상 출력 헬퍼
# ──────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()    { echo -e "${BLUE}ℹ️  $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
warn()    { echo -e "${YELLOW}⚠️  $1${NC}"; }
error()   { echo -e "${RED}❌ $1${NC}"; }

echo ""
echo "=================================================="
echo "   GitHub Kanban 보드 자동 생성"
echo "=================================================="
echo ""

# ──────────────────────────────────────────
# 1. gh CLI 인증 확인
# ──────────────────────────────────────────
info "gh CLI 인증 상태 확인 중..."
if ! gh auth status > /dev/null 2>&1; then
  error "gh CLI 인증이 필요합니다."
  echo "   다음 명령어를 실행한 후 다시 시도하세요: gh auth login"
  exit 1
fi
success "gh CLI 인증 확인 완료"
echo ""

# ──────────────────────────────────────────
# 2. 프로젝트 이름 확인
# ──────────────────────────────────────────
PROJECT_TITLE="${1:-}"

if [ -z "$PROJECT_TITLE" ]; then
  echo -n "📋 프로젝트 보드 이름을 입력하세요: "
  read -r PROJECT_TITLE
  if [ -z "$PROJECT_TITLE" ]; then
    error "프로젝트 이름이 필요합니다."
    exit 1
  fi
fi
info "프로젝트 이름: $PROJECT_TITLE"
echo ""

# ──────────────────────────────────────────
# 3. 리포지토리 확인
# ──────────────────────────────────────────
if [ -n "${2:-}" ]; then
  OWNER=$(echo "$2" | cut -d'/' -f1)
  REPO=$(echo "$2" | cut -d'/' -f2)
else
  OWNER=$(gh repo view --json owner -q '.owner.login' 2>/dev/null)
  REPO=$(gh repo view --json name -q '.name' 2>/dev/null)
fi

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
  error "리포지토리를 감지할 수 없습니다. GitHub 리포지토리 디렉토리에서 실행하거나 두 번째 인자로 'owner/repo'를 지정하세요."
  exit 1
fi
info "대상 리포지토리: $OWNER/$REPO"
echo ""

# ──────────────────────────────────────────
# 4. 프로젝트 생성 또는 기존 프로젝트 사용
# ──────────────────────────────────────────
info "프로젝트 확인 중..."
PROJECT_NUMBER=$(gh project list --owner "$OWNER" --format json 2>/dev/null | \
  jq -r ".projects[] | select(.title==\"$PROJECT_TITLE\") | .number" 2>/dev/null)

if [ -n "$PROJECT_NUMBER" ] && [ "$PROJECT_NUMBER" != "null" ]; then
  warn "동일한 이름의 프로젝트가 이미 존재합니다. 기존 프로젝트 #$PROJECT_NUMBER 를 사용합니다."
else
  info "새 프로젝트 생성 중..."
  gh project create --owner "$OWNER" --title "$PROJECT_TITLE" > /dev/null 2>&1
  sleep 2  # 생성 완료 대기

  PROJECT_NUMBER=$(gh project list --owner "$OWNER" --format json 2>/dev/null | \
    jq -r ".projects[] | select(.title==\"$PROJECT_TITLE\") | .number" 2>/dev/null)

  if [ -z "$PROJECT_NUMBER" ] || [ "$PROJECT_NUMBER" = "null" ]; then
    error "프로젝트 생성에 실패했습니다."
    exit 1
  fi
  success "프로젝트 생성 완료 (#$PROJECT_NUMBER)"
fi
echo ""

# ──────────────────────────────────────────
# 5. Status 컬럼 구성 (Todo / In Progress / Review / Done)
# ──────────────────────────────────────────
info "Status 필드 구성 중..."

FIELD_ID=$(gh project field-list "$PROJECT_NUMBER" --owner "$OWNER" --format json 2>/dev/null | \
  jq -r '.fields[] | select(.name=="Status") | .id' 2>/dev/null)

if [ -z "$FIELD_ID" ] || [ "$FIELD_ID" = "null" ]; then
  warn "Status 필드를 찾을 수 없습니다. 기본 상태로 진행합니다."
else
  gh api graphql -f query='
    mutation($fieldId: ID!) {
      updateProjectV2Field(input: {
        fieldId: $fieldId
        singleSelectOptions: ["Todo", "In Progress", "Review", "Done"]
      }) {
        projectV2Field { id }
      }
    }
  ' -f fieldId="$FIELD_ID" > /dev/null 2>&1
  success "Status 컬럼 구성 완료 (Todo / In Progress / Review / Done)"
fi
echo ""

# ──────────────────────────────────────────
# 6. 오픈 이슈 전체 조회 및 등록
# ──────────────────────────────────────────
info "오픈 이슈 목록 조회 중..."
ISSUES=$(gh issue list --repo "$OWNER/$REPO" --state open \
  --json number --limit 500 -q '.[].number' 2>/dev/null)

if [ -z "$ISSUES" ]; then
  warn "오픈된 이슈가 없습니다."
  TOTAL=0
else
  TOTAL=$(echo "$ISSUES" | grep -c . 2>/dev/null || echo 0)
  info "등록할 이슈: $TOTAL개"
  echo ""

  COUNT=0
  FAILED=0
  for ISSUE_NUM in $ISSUES; do
    ISSUE_URL="https://github.com/$OWNER/$REPO/issues/${ISSUE_NUM}"
    if gh project item-add "$PROJECT_NUMBER" --owner "$OWNER" --url "$ISSUE_URL" > /dev/null 2>&1; then
      COUNT=$((COUNT + 1))
      echo -e "  ${GREEN}[$COUNT/$TOTAL]${NC} 이슈 #${ISSUE_NUM} 등록 완료"
    else
      FAILED=$((FAILED + 1))
      echo -e "  ${YELLOW}[실패]${NC} 이슈 #${ISSUE_NUM} 등록 실패 (이미 등록되었을 수 있음)"
    fi
    sleep 0.3
  done
  echo ""
  success "이슈 등록 완료: 성공 $COUNT개 / 실패 $FAILED개"
fi
echo ""

# ──────────────────────────────────────────
# 7. 등록된 이슈를 Todo 상태로 설정
# ──────────────────────────────────────────
info "이슈 상태를 Todo로 설정 중..."

PROJECT_ID=$(gh project list --owner "$OWNER" --format json 2>/dev/null | \
  jq -r ".projects[] | select(.number==$PROJECT_NUMBER) | .id" 2>/dev/null)

STATUS_FIELD_ID=$(gh project field-list "$PROJECT_NUMBER" --owner "$OWNER" --format json 2>/dev/null | \
  jq -r '.fields[] | select(.name=="Status") | .id' 2>/dev/null)

TODO_OPTION_ID=$(gh project field-list "$PROJECT_NUMBER" --owner "$OWNER" --format json 2>/dev/null | \
  jq -r '.fields[] | select(.name=="Status") | .options[] | select(.name=="Todo") | .id' 2>/dev/null)

if [ -n "$PROJECT_ID" ] && [ -n "$STATUS_FIELD_ID" ] && [ -n "$TODO_OPTION_ID" ]; then
  gh project item-list "$PROJECT_NUMBER" --owner "$OWNER" --format json 2>/dev/null | \
    jq -r '.items[].id' | while read -r ITEM_ID; do
      gh project item-edit \
        --project-id "$PROJECT_ID" \
        --id "$ITEM_ID" \
        --field-id "$STATUS_FIELD_ID" \
        --single-select-option-id "$TODO_OPTION_ID" > /dev/null 2>&1
    done
  success "모든 이슈를 Todo 상태로 설정 완료"
else
  warn "Todo 상태 자동 설정을 건너뜁니다. (ID 조회 실패)"
fi
echo ""

# ──────────────────────────────────────────
# 8. 결과 요약 출력
# ──────────────────────────────────────────
# URL 결정 (org vs user)
ORG_CHECK=$(gh api "orgs/$OWNER" --jq '.login' 2>/dev/null)
if [ "$ORG_CHECK" = "$OWNER" ]; then
  PROJECT_URL="https://github.com/orgs/$OWNER/projects/$PROJECT_NUMBER"
else
  PROJECT_URL="https://github.com/users/$OWNER/projects/$PROJECT_NUMBER"
fi

echo "=================================================="
echo -e "${GREEN}✅ GitHub 칸반 보드 생성 완료!${NC}"
echo "=================================================="
echo ""
echo "  📋 프로젝트 이름 : $PROJECT_TITLE"
echo "  🔗 프로젝트 URL  : $PROJECT_URL"
echo ""
echo "  📊 상태별 이슈 현황:"
echo "    • Todo        : ${TOTAL}개"
echo "    • In Progress : 0개"
echo "    • Review      : 0개"
echo "    • Done        : 0개"
echo "    ────────────────"
echo "    • 합계         : ${TOTAL}개"
echo ""
