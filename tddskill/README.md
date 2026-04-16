# TDD 스킬 (Claude Code Custom Skill)

TDD(테스트 주도 개발) 워크플로우를 단계별로 수행하는 Claude Code 커스텀 스킬입니다.

## 파일 구조

```
tddskill/
├── tdd.md              # /tdd 슬래시 커맨드 (명시적 호출용)
├── skill/
│   └── SKILL.md        # 자동 트리거 스킬 (자연어 감지용)
└── tdd-workflow-ko.md  # TDD 워크플로우 상세 가이드 (한국어)
```

### `tdd.md` vs `skill/SKILL.md` 차이

| | `tdd.md` | `skill/SKILL.md` |
|---|---|---|
| 설치 위치 | `~/.claude/commands/` | `~/.claude/skills/tdd/` |
| 호출 방법 | `/tdd 기능설명` (명시적) | "TDD로 구현해줘" (자연어 자동 감지) |
| 용도 | 슬래시 커맨드 | 대화 문맥 기반 자동 실행 |

## 설치 방법

> **사전 요구사항:** [Claude Code](https://claude.ai/code)가 설치되어 있어야 합니다.

### A. 슬래시 커맨드 설치 (`/tdd`)

명시적으로 `/tdd 기능설명` 형태로 호출하는 방식입니다.

**전역 설치** — 모든 프로젝트에서 사용:

```bash
mkdir -p ~/.claude/commands
curl -o ~/.claude/commands/tdd.md \
  https://raw.githubusercontent.com/ischung/tddskill/main/tdd.md
```

**프로젝트 전용 설치**:

```bash
mkdir -p .claude/commands
curl -o .claude/commands/tdd.md \
  https://raw.githubusercontent.com/ischung/tddskill/main/tdd.md
```

### B. 자동 트리거 스킬 설치 (자연어 감지)

"TDD로 구현해줘", "테스트 먼저 짜줘" 같은 자연어만으로 자동 실행되는 방식입니다.

**전역 설치**:

```bash
mkdir -p ~/.claude/skills/tdd
curl -o ~/.claude/skills/tdd/SKILL.md \
  https://raw.githubusercontent.com/ischung/tddskill/main/skill/SKILL.md
```

### C. 둘 다 설치 (권장)

```bash
# 슬래시 커맨드
mkdir -p ~/.claude/commands
curl -o ~/.claude/commands/tdd.md \
  https://raw.githubusercontent.com/ischung/tddskill/main/tdd.md

# 자동 트리거 스킬
mkdir -p ~/.claude/skills/tdd
curl -o ~/.claude/skills/tdd/SKILL.md \
  https://raw.githubusercontent.com/ischung/tddskill/main/skill/SKILL.md
```

### 설치 확인

Claude Code를 열고 다음 중 하나를 시도합니다:

```
/tdd                    # 슬래시 커맨드 확인
TDD로 구현해줘          # 자동 트리거 확인
```

## 사용 방법

```
/tdd [구현할 기능 설명]
```

**예시:**
```
/tdd 두 수를 더하는 계산기 함수
/tdd 사용자 로그인 유효성 검사
/tdd 장바구니에 상품 추가 기능
```

## TDD 사이클

```
🔴 RED     → 실패하는 테스트 먼저 작성
🟢 GREEN   → 최소한의 코드로 테스트 통과
🔵 REFACTOR → 동작 유지하며 코드 개선
🔁 반복
```

## 주요 기능

- **STEP 0:** 요구사항 분석 및 TODO 테스트 목록 자동 생성
- **STEP 1 (RED):** AAA 패턴(Arrange-Act-Assert)으로 실패 테스트 작성
- **STEP 2 (GREEN):** 최소 구현으로 테스트 통과
- **STEP 3 (REFACTOR):** 코드 스멜 제거 및 개선
- **STEP 4:** 다음 사이클 자동 진행

## 참고 문서

- [TDD 워크플로우 상세 가이드](tdd-workflow-ko.md)
