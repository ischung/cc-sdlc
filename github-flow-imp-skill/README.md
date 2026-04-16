# github-flow-impl

GitHub Projects 보드의 이슈를 자동으로 구현하는 Claude Code 스킬 + 슬래시 커맨드.

---

## 시작 전 체크리스트

새 프로젝트에서 `/impl`을 처음 사용하기 전에 아래 항목을 순서대로 완료해야 합니다.

```
[ ] 1. gh CLI 설치 (2.x 이상)
[ ] 2. jq 설치
[ ] 3. gh auth login + project 스코프 추가
[ ] 4. 칸반 보드 생성 (컬럼명 정확히 일치)
[ ] 5. KANBAN_TOKEN PAT 발급 + 저장소 Secret 등록
```

> ✅ **KANBAN_TOKEN 미등록 시 동작**: PR 체크는 빨간 X 없이 성공하며, "KANBAN_TOKEN 미등록 — 칸반 이동 스킵" 알림만 뜸. 등록하는 순간 자동화가 작동 (graceful degradation).

---

## 사전 요구사항

### 1. gh CLI 설치

```bash
# macOS
brew install gh

# 설치 확인
gh --version  # 2.x 이상 필요
```

### 2. jq 설치

```bash
brew install jq
```

### 3. GitHub 인증

#### 방법 A — 브라우저 로그인 (권장)

```bash
gh auth login
```

프롬프트 순서:
1. `GitHub.com` 선택
2. `HTTPS` 선택
3. `Login with a web browser` 선택
4. 터미널에 표시된 one-time code 복사
5. 브라우저에서 https://github.com/login/device 접속 후 코드 붙여넣기
6. Authorize 클릭 → 인증 완료

`gh project` 명령어를 쓰려면 `project` 스코프를 추가해야 합니다:

```bash
gh auth refresh -s project
```

#### 방법 B — Personal Access Token (PAT) 사용

브라우저 인증이 불가한 환경(서버, CI 등)에서 사용.

1. https://github.com/settings/tokens 접속
2. `Generate new token (classic)` 클릭
3. 스코프 체크: `repo`, `read:org`, `project`
4. 토큰 복사 후 아래 명령 실행:

```bash
echo YOUR_TOKEN | gh auth login --with-token
gh auth status  # ✓ Token scopes: repo, read:org, project
```

### 4. 칸반 보드 생성

`/kanban-create` 스킬로 자동 생성하거나, 수동 생성 시 **Status 컬럼명이 정확히 일치**해야 합니다.

| 컬럼명 | 비고 |
|--------|------|
| `Todo` | 대소문자 정확히 일치 |
| `In Progress` | 공백 포함 |
| `Review` | |
| `Done` | |

---

## 칸반 자동화 인증 설정 — `KANBAN_TOKEN` PAT

PR 오픈/머지 시 칸반 이슈를 자동 이동하려면 GitHub Actions에 인증이 필요합니다.
기본 `GITHUB_TOKEN`은 GitHub Projects V2 접근 권한이 없으므로 별도 PAT가 필요합니다.

> **흐름 요약**
> PR 오픈 → `kanban-auto-review.yml` → 이슈를 **Review**로 이동
> PR 머지 → `kanban-auto-done.yml` → 이슈를 **Done**으로 이동

### PAT 발급

1. https://github.com/settings/tokens/new 접속
2. 아래 값으로 설정:
   - **Note**: `kanban-automation`
   - **Expiration**: `No expiration` 또는 90 days
   - **Select scopes** — 아래 **4가지 모두 체크**:

| 스코프 | 필요한 이유 |
|--------|------------|
| `repo` | 저장소 읽기/쓰기 |
| `project` | GitHub Projects 보드 읽기/쓰기 |
| `read:org` | 오너 타입(org/user) 판별 |
| `read:discussion` | GitHub 내부 API 요구 |

> ⚠️ 4가지 중 하나라도 빠지면 Actions 실행 시 오류 발생:
> - `project` 누락 → `Resource not accessible by integration`
> - `read:org` 누락 → `missing required scopes [read:org]`

3. **Generate token** 클릭 → 표시된 `ghp_xxx...` 값을 즉시 복사 (한 번만 표시)

### 저장소 Secret 등록

**웹 UI 방식**:
1. 저장소 → 상단 **Settings** 탭
2. 좌측 **Secrets and variables** → **Actions**
3. **New repository secret** 클릭
4. **Name**: `KANBAN_TOKEN` (대소문자 정확히) / **Secret**: 발급받은 PAT 붙여넣기
5. **Add secret**

**CLI 방식**:
```bash
gh secret set KANBAN_TOKEN --repo OWNER/REPO
# 프롬프트에 PAT 붙여넣기
```

### 등록 및 동작 확인

```bash
gh secret list --repo OWNER/REPO   # KANBAN_TOKEN 보이면 OK
GH_TOKEN=<발급한 PAT> gh project list --owner <your-username>
# 프로젝트 목록 출력되면 스코프 구성도 정상
```

### 미등록 상태의 동작 (Graceful Skip)

`_kanban-move.yml`은 runtime guard를 탑재하여 `KANBAN_TOKEN`이 없어도 **PR 체크를 빨간 X로 실패시키지 않습니다**. Actions 로그에 `::notice::KANBAN_TOKEN 미등록 — 칸반 이동 스킵` 만 남기고 성공으로 끝납니다. 등록하는 순간부터 자동화가 켜집니다.

---

## 설치 방법

### A. 모든 프로젝트에서 사용 (글로벌 스코프, 권장)

```bash
cd ~/Downloads
unzip github-flow-impl.zip -d github-flow-impl
cd github-flow-impl

mkdir -p ~/.claude/commands
mkdir -p ~/.claude/skills/github-flow-impl

cp claude/commands/implement.md ~/.claude/commands/
cp claude/commands/impl.md      ~/.claude/commands/
cp claude/skills/github-flow-impl/SKILL.md ~/.claude/skills/github-flow-impl/
```

### B. 특정 프로젝트에만 적용 (프로젝트 스코프)

```bash
cd ~/Downloads
unzip github-flow-impl.zip -d github-flow-impl
cd github-flow-impl

mkdir -p /your-project/.claude/commands
mkdir -p /your-project/.claude/skills/github-flow-impl

cp claude/commands/implement.md /your-project/.claude/commands/
cp claude/commands/impl.md      /your-project/.claude/commands/
cp claude/skills/github-flow-impl/SKILL.md /your-project/.claude/skills/github-flow-impl/
```

---

## 사용법

```bash
# Todo 최우선 이슈 자동 선택 후 구현
/implement

# 특정 이슈 번호 지정
/implement #42

# 이슈 내용 직접 입력
/implement --inline #47 로그인 구현 ... AC: - [ ] 항목1

# 단축어
/impl
/impl #42
```

---

## 파일 구조

```
.claude/
├── commands/
│   ├── implement.md   # /implement 슬래시 커맨드
│   └── impl.md        # /impl 단축어
└── skills/
    └── github-flow-impl/
        └── SKILL.md   # 스킬 본체 (지침 전체 포함)
```

---

## 트러블슈팅

### PR 머지 후 이슈가 Done으로 이동하지 않는 경우

1. **워크플로우 파일 확인**
```bash
ls .github/workflows/
# _kanban-move.yml, kanban-auto-done.yml, kanban-auto-review.yml 이 있어야 함
```
없으면 `/implement` 실행 → Step 0.5에서 자동 생성

2. **시크릿 등록 여부 확인**
```bash
gh secret list --repo OWNER/REPO
# KANBAN_TOKEN 이 있어야 함
```

3. **PR 본문에 `Closes #이슈번호` 포함 여부 확인**
```
Closes #42  ← 이 키워드가 없으면 이슈 연결 안 됨
```

4. **Actions 탭에서 실패 로그 확인**
```bash
gh run list --workflow=kanban-auto-done.yml --limit 5
gh run view <RUN_ID> --log
```
