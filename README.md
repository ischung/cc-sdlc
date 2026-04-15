# cc-sdlc — 소프트웨어 개발 자동화 Claude Code 스킬 패키지

소프트웨어 개발 전체 라이프사이클(기획 → 설계 → 이슈 관리 → 구현 → CI/CD)을 자동화하는 **Claude Code 커스텀 스킬** 6종 패키지입니다.

> **cc-sdlc** = Claude Code + Software Development Life Cycle

---

## 목차

1. [사전 준비](#1-사전-준비)
2. [설치](#2-설치)
3. [설치 확인](#3-설치-확인)
4. [사용 방법](#4-사용-방법)
5. [전체 워크플로우 예시](#5-전체-워크플로우-예시)
6. [제거](#6-제거)
7. [포함된 스킬](#포함된-스킬-6종)
8. [지원 도구 로드맵](#지원-도구-로드맵)

---

## 1. 사전 준비

cc-sdlc를 사용하기 전에 아래 도구들이 설치되어 있어야 합니다.

### Node.js 설치 확인

`npx` 명령어를 사용하려면 **Node.js 14 이상**이 필요합니다.

```bash
node --version   # v14.0.0 이상이어야 함
```

Node.js가 없다면 [nodejs.org](https://nodejs.org)에서 설치하세요.

### Claude Code 설치 확인

스킬은 Claude Code 환경에 설치됩니다. Claude Code가 실행되는지 확인하세요.

```bash
claude --version
```

### GitHub CLI 설치 확인 (칸반/이슈 스킬 사용 시 필요)

`/kanban-create`, `/implement` 등 GitHub 관련 스킬을 사용할 경우 필요합니다.

```bash
# 설치 여부 확인
gh --version

# 설치되어 있지 않다면 (macOS 기준)
brew install gh

# GitHub 계정 인증
gh auth login
```

---

## 2. 설치

터미널을 열고 아래 명령어 한 줄을 실행하면 6개의 스킬과 10개의 커맨드가 자동으로 설치됩니다.

```bash
npx github:ischung/cc-sdlc
```

명령어를 실행하면 다음과 같은 화면이 출력됩니다.

```
╔══════════════════════════════════════════════╗
║     cc-sdlc — Claude Code SDLC Skills v1.0  ║
╚══════════════════════════════════════════════╝

[설치 시작]

  ▸ github-kanban
    ✔ 스킬 설치: ~/.claude/skills/github-kanban/SKILL.md
    ✔ 커맨드 설치: /kanban-add-issues
    ✔ 커맨드 설치: /kanban-create
    ✔ 커맨드 설치: /kanban-status

  ▸ write-prd
    ✔ 스킬 설치: ~/.claude/skills/write-prd/SKILL.md
    ✔ 커맨드 설치: /write-prd
  ...

[설치 완료]

  → 스킬:    6개  →  ~/.claude/skills
  → 커맨드:  10개  →  ~/.claude/commands

  Claude Code를 재시작하면 모든 스킬이 활성화됩니다.
```

설치가 완료되면 **Claude Code를 완전히 종료한 뒤 다시 실행**하세요. 재시작 후 모든 스킬과 커맨드가 활성화됩니다.

### 설치 위치

설치 명령어는 아래 두 폴더에 파일을 복사합니다.

```
~/.claude/
├── skills/               ← 스킬 정의 파일 (자동 트리거용)
│   ├── github-kanban/SKILL.md
│   ├── write-prd/SKILL.md
│   ├── write-techspec/SKILL.md
│   ├── ci-cd-pipeline/SKILL.md
│   ├── tdd/SKILL.md
│   └── github-flow-impl/SKILL.md
└── commands/             ← 슬래시 커맨드 파일
    ├── write-prd.md
    ├── write-techspec.md
    ├── generate-issues.md
    ├── kanban-create.md
    ├── kanban-add-issues.md
    ├── kanban-status.md
    ├── cicd-pipeline.md
    ├── tdd.md
    ├── implement.md
    └── impl.md
```

---

## 3. 설치 확인

설치가 제대로 되었는지 확인하려면 다음 명령어를 실행합니다.

```bash
npx github:ischung/cc-sdlc list
```

6개 스킬과 10개 커맨드 앞에 모두 ✔ 표시가 나오면 정상입니다.

```
[설치 현황]

  ✔  스킬: ci-cd-pipeline
       ✔  /cicd-pipeline
  ✔  스킬: github-flow-impl
       ✔  /impl
       ✔  /implement
  ✔  스킬: github-kanban
       ✔  /kanban-add-issues
       ✔  /kanban-create
       ✔  /kanban-status
  ✔  스킬: tdd
       ✔  /tdd
  ✔  스킬: write-prd
       ✔  /write-prd
  ✔  스킬: write-techspec
       ✔  /generate-issues
       ✔  /write-techspec
```

---

## 4. 사용 방법

Claude Code를 열고 작업 중인 프로젝트 폴더에서 아래 커맨드를 사용합니다.  
슬래시 커맨드(`/커맨드명`) 또는 자연어로 입력하면 스킬이 자동으로 실행됩니다.

---

### `/write-prd` — PRD(제품 요구사항 문서) 작성

새 기능이나 프로젝트의 기획 문서를 작성할 때 사용합니다. AI가 PM 코치 역할을 맡아 8단계 질문을 통해 PRD를 완성해 줍니다.

```
/write-prd
```

또는 자연어로 입력해도 됩니다.

```
PRD 작성해줘
제품 기획서 만들어줘
```

**진행 순서:**

| 단계 | 내용 |
|------|------|
| Phase 0 | 아이디어 청취 — 만들고 싶은 것을 자유롭게 설명 |
| Phase 1 | 프로젝트 목표 정의 — 이 제품이 해결하는 핵심 문제 |
| Phase 2 | 범위 확정 — 이번 버전에서 할 것 / 하지 않을 것 |
| Phase 3 | 대상 사용자 & 유저 스토리 |
| Phase 4 | KPI 정의 — 성공 기준 지표 |
| Phase 5 | 상세 기능 요건 |
| Phase 6 | UI/UX 요건 |
| Phase 7 | 기술적 제약 & 최종 저장 |

각 단계마다 AI가 질문을 하고, 답변을 승인하면 다음 단계로 진행됩니다. 완료되면 `prd.md` 파일로 저장됩니다.

---

### `/write-techspec` — TechSpec(기술 명세서) 작성

PRD를 기반으로 시스템 아키텍처, 데이터 모델, API 명세를 포함한 기술 명세서를 작성합니다. 먼저 `/write-prd`로 PRD를 완성한 뒤 실행하세요.

```
/write-techspec
```

또는 자연어로 입력해도 됩니다.

```
TechSpec 작성해줘
기술 명세서 만들어줘
```

TechSpec에는 다음 내용이 포함됩니다.

- 시스템 아키텍처 다이어그램 (Mermaid)
- 기술 스택 선택 근거
- 데이터 모델 및 ERD
- REST API 명세
- 프론트엔드 / 백엔드 상세 기능 명세
- 개발 마일스톤 (Phase 1 ~ 4)

---

### `/generate-issues` — GitHub 이슈 자동 발행

TechSpec을 분석하여 개발 작업을 GitHub 이슈로 자동 분할하고 등록합니다. `/write-techspec`으로 TechSpec을 완성한 뒤 실행하세요.

```
/generate-issues
```

또는 자연어로 입력해도 됩니다.

```
이슈 발행해줘
GitHub 이슈 만들어줘
```

INVEST 원칙(Independent · Negotiable · Valuable · Estimable · Small · Testable)에 따라 작업 단위를 분割하여 이슈를 생성합니다.

---

### `/kanban-create` — GitHub Projects 칸반 보드 생성

현재 GitHub 저장소에 **Todo / In Progress / Review / Done** 4개 컬럼으로 구성된 칸반 보드를 자동으로 생성합니다.

```
/kanban-create
```

또는 자연어로 입력해도 됩니다.

```
칸반 보드 만들어줘
GitHub 프로젝트 생성해줘
```

> **전제 조건:** `gh auth login`으로 GitHub 인증이 완료되어 있어야 합니다.

---

### `/kanban-add-issues` — 칸반 보드에 이슈 추가

저장소의 열린 이슈 전체를 칸반 보드의 Todo 컬럼에 자동으로 배치합니다.

```
/kanban-add-issues
```

---

### `/kanban-status` — 칸반 보드 현황 조회

현재 칸반 보드의 컬럼별 이슈 수와 목록을 요약해서 보여줍니다.

```
/kanban-status
```

---

### `/cicd-pipeline` — CI/CD 파이프라인 구축

프로젝트의 언어와 구조를 분석하여 GitHub Actions 기반 CI/CD 파이프라인을 구성하는 이슈 7개를 자동으로 생성합니다.

```
/cicd-pipeline
```

또는 자연어로 입력해도 됩니다.

```
CI/CD 파이프라인 구축해줘
GitHub Actions 설정해줘
```

생성되는 이슈 목록:

1. 기존 워크플로우 정리
2. CI — Static Analysis & Security Scan
3. CI — Unit/Integration Test (CI Gate)
4. CD — Docker Build & Push
5. CD — Container Security Scan
6. CD — Staging 배포 & E2E Test
7. CD — GitHub Pages 배포 & Smoke Test

---

### `/tdd` — TDD 워크플로우

테스트 주도 개발(Test-Driven Development) 방식으로 기능을 구현할 때 사용합니다. AI가 Red → Green → Refactor 사이클을 단계별로 안내합니다.

```
/tdd 로그인 기능 구현
```

또는 자연어로 입력해도 됩니다.

```
TDD로 구현해줘
테스트 먼저 짜줘
```

**진행 순서:**

| 단계 | 내용 |
|------|------|
| STEP 0 | TODO 테스트 목록 생성 — 구현할 기능을 테스트 케이스로 분해 |
| STEP 1 (RED) | 실패하는 테스트 작성 — AAA 패턴(Arrange · Act · Assert) 적용 |
| STEP 2 (GREEN) | 최소한의 코드 작성으로 테스트 통과 |
| STEP 3 (REFACTOR) | 동작을 유지하면서 코드 품질 개선 |

---

### `/implement` — GitHub 이슈 자동 구현

칸반 보드의 Todo 컬럼에서 이슈를 선택하여 GitHub Flow 방식으로 자동 구현합니다. 브랜치 생성 → 코드 작성 → PR 생성까지 자동으로 처리합니다.

```
/implement          # Todo 컬럼의 최우선 이슈 자동 선택
/implement #42      # 이슈 번호 직접 지정
/impl               # /implement 단축 커맨드
```

**전제 조건:**

- `gh` CLI 2.x 이상이 설치되어 있어야 합니다.
- `jq`가 설치되어 있어야 합니다. (`brew install jq`)
- GitHub 인증 스코프: `repo`, `read:org`, `read:discussion`, `project`
- `KANBAN_TOKEN` PAT를 GitHub Actions Secret으로 등록해야 합니다.

---

## 5. 전체 워크플로우 예시

새 프로젝트를 시작할 때 cc-sdlc 스킬을 순서대로 사용하는 예시입니다.

```mermaid
flowchart LR
    A[아이디어] -->|/write-prd| B[PRD 문서]
    B -->|/write-techspec| C[TechSpec + 아키텍처]
    C -->|/generate-issues| D[GitHub 이슈]
    D -->|/kanban-create| E[칸반 보드]
    E -->|/implement| F[코드 구현]
    F -->|/tdd| G[TDD 검증]
    C -->|/cicd-pipeline| H[CI/CD 파이프라인]
    G --> H
```

**단계별 실행 순서:**

```
1단계: /write-prd          → 기획 문서(prd.md) 완성
2단계: /write-techspec     → 기술 명세서 완성
3단계: /generate-issues    → GitHub 이슈 자동 등록
4단계: /kanban-create      → 칸반 보드 생성
5단계: /kanban-add-issues  → 이슈를 보드에 배치
6단계: /cicd-pipeline      → CI/CD 파이프라인 이슈 생성
7단계: /implement          → 이슈 하나씩 자동 구현 (반복)
       /tdd                → 각 기능을 TDD로 검증 (반복)
```

---

## 6. 제거

설치된 모든 스킬과 커맨드를 제거하려면 다음 명령어를 실행합니다.

```bash
npx github:ischung/cc-sdlc uninstall
```

실행하면 `~/.claude/skills/` 안의 6개 스킬 폴더와 `~/.claude/commands/` 안의 10개 커맨드 파일이 삭제됩니다.

```
[제거 시작]

  ▸ github-kanban
    ✔ 스킬 제거: ~/.claude/skills/github-kanban
    ✔ 커맨드 제거: /kanban-add-issues
    ✔ 커맨드 제거: /kanban-create
    ✔ 커맨드 제거: /kanban-status
  ...

[제거 완료]

  → 6개 스킬이 제거되었습니다.
```

제거 후 **Claude Code를 재시작**하면 스킬이 비활성화됩니다.

---

## 포함된 스킬 (6종)

| 스킬 | 커맨드 | 설명 |
|------|--------|------|
| **write-prd** | `/write-prd` | 시니어 PM 코치가 1:1 대화로 PRD 단계별 완성 |
| **write-techspec** | `/write-techspec` `/generate-issues` | PRD → TechSpec 작성 + GitHub 이슈 자동 발행 |
| **github-kanban** | `/kanban-create` `/kanban-add-issues` `/kanban-status` | GitHub Projects 칸반 보드 자동 구성 |
| **ci-cd-pipeline** | `/cicd-pipeline` | GitHub Actions CI/CD 파이프라인 이슈 자동 생성 |
| **tdd** | `/tdd` | TDD(Red→Green→Refactor) 워크플로우 페어 프로그래밍 |
| **github-flow-impl** | `/implement` `/impl` | 칸반 보드 이슈 자동 선택 → GitHub Flow 구현 |

---

## 지원 도구 로드맵

| 도구 | 상태 |
|------|------|
| Claude Code | ✅ 지원 |
| OpenAI Codex CLI | 🔜 예정 |
| GitHub Copilot CLI | 🔜 예정 |

---

## 패키지 구조

```
cc-sdlc/
├── package.json
├── bin/
│   └── install.js       ← npx 진입점 (Node.js)
├── dist/                ← 배포용 스킬 번들
│   ├── github-kanban/
│   ├── write-prd/
│   ├── write-techspec/
│   ├── ci-cd-pipeline/
│   ├── tdd/
│   └── github-flow-impl/
└── README.md
```
