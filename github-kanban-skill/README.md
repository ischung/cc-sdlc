# 🗂️ GitHub Kanban Skill for Claude

Claude (Cowork / Claude Code)에서 **GitHub Projects 칸반 보드를 자동으로 생성**하고 오픈 이슈를 등록하는 스킬입니다.

## ✨ 기능

- **칸반 보드 자동 생성**: GitHub Projects에 보드를 만들고 `Todo / In Progress / Review / Done` 4개 컬럼 구성
- **이슈 일괄 등록**: 리포지토리의 모든 오픈 이슈를 Todo에 자동 배치
- **보드 현황 조회**: 컬럼별 이슈 수와 목록을 한눈에 확인
- **3가지 슬래시 커맨드** 제공 (Claude Code에서 바로 사용 가능)

## 📦 설치 방법

### Claude Code 슬래시 커맨드로 설치

```bash
# 1. 이 저장소를 클론
git clone https://github.com/YOUR_USERNAME/github-kanban-skill.git

# 2-A. 현재 프로젝트에만 적용
mkdir -p .claude/commands
cp github-kanban-skill/commands/*.md .claude/commands/

# 2-B. 전체 사용자에게 적용 (어디서든 사용 가능)
mkdir -p ~/.claude/commands
cp github-kanban-skill/commands/*.md ~/.claude/commands/
```

### Claude Cowork (데스크탑 앱) 스킬로 설치

```bash
mkdir -p ~/.claude/skills/github-kanban
cp -r github-kanban-skill/* ~/.claude/skills/github-kanban/
```

## 🚀 사용 방법

### 슬래시 커맨드 (Claude Code)

| 커맨드 | 설명 | 예시 |
|--------|------|------|
| `/kanban-create` | 새 칸반 보드 생성 + 이슈 전체 등록 | `/kanban-create "Sprint 1"` |
| `/kanban-add-issues` | 기존 보드에 이슈 추가 | `/kanban-add-issues 42` |
| `/kanban-status` | 보드 현황 조회 | `/kanban-status 42` |

### 자연어 (Claude Cowork / Claude Code)

```
"현재 리포지토리 이슈들을 칸반 보드로 관리하고 싶어"
"GitHub Projects에 'Sprint 1'이라는 보드 만들어줘"
"my-org/my-repo 이슈들을 '백엔드 보드'에 등록해줘"
```

### 헬퍼 스크립트 직접 실행

```bash
# 현재 리포지토리에 보드 생성
bash scripts/create_kanban.sh "My Board"

# 특정 리포지토리에 보드 생성
bash scripts/create_kanban.sh "Sprint 1" "my-org/my-repo"
```

## ⚙️ 전제 조건

- [GitHub CLI (`gh`)](https://cli.github.com/) 설치 및 인증 완료
  ```bash
  gh auth login
  ```
- `jq` 설치 (`brew install jq` / `apt install jq`)

## 📁 파일 구조

```
github-kanban-skill/
├── SKILL.md                    # Claude 스킬 정의 (핵심 파일)
├── README.md                   # 이 파일
├── commands/
│   ├── kanban-create.md        # /kanban-create 슬래시 커맨드
│   ├── kanban-add-issues.md    # /kanban-add-issues 슬래시 커맨드
│   └── kanban-status.md        # /kanban-status 슬래시 커맨드
└── scripts/
    └── create_kanban.sh        # 독립 실행 가능한 헬퍼 스크립트
```

## 📋 출력 예시

```
✅ GitHub 칸반 보드 생성 완료!

📋 프로젝트 이름: Sprint 1
🔗 프로젝트 URL: https://github.com/users/my-account/projects/5

📊 상태별 이슈 현황:
  • Todo       : 12개
  • In Progress: 0개
  • Review     : 0개
  • Done       : 0개
  ──────────────────
  • 합계        : 12개
```

## 🤝 기여

이슈나 PR은 언제든지 환영합니다!

## 📄 라이선스

MIT License
# github-kanban-skill
