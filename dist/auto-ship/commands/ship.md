---
description: 단일 이슈를 구현하고 CI/CD 파이프라인을 통과할 때까지 자동으로 처리합니다. 사용법: /ship [#이슈번호]
argument-hint: "[#이슈번호]"
allowed-tools: Bash(git *), Bash(gh *)
---

`auto-ship` 스킬의 지침에 따라 아래 인자를 처리하라.

인자: $ARGUMENTS

- 인자가 없으면 → **자동 선택 모드**: GitHub Projects Todo 열 최상단 이슈 자동 선택
- 인자가 `#숫자` 또는 `숫자` 형태이면 → **번호 지정 모드**: 해당 이슈 번호로 처리

Step 0(환경 감지) → Step 0.5(칸반 자동화 확인) → Step 1(이슈 선정) → Step 2(In Progress 이동) → Step 3(브랜치 생성) → Step 4(코드 구현) → Step 5(로컬 테스트) → Step 6(PR 생성) → Step 7(CI/CD 모니터링 루프) → Step 8(완료 보고) 순서로 진행한다.

CI/CD 실패 시 최대 3회까지 자동 수정 후 재시도한다. 3회 초과 시 사용자에게 수동 개입을 요청하고 중단한다.
