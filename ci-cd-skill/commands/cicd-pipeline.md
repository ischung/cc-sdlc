---
description: 프로젝트 아키텍처를 분석하여 GitHub Actions 기반 CI/CD 파이프라인 구축 이슈를 자동 생성하고 cicd-issues.md에 저장
argument-hint: "[--dry-run | --force]"
allowed-tools: Bash(git *), Bash(gh *), Bash(find *), Bash(ls *), Bash(cat *), Bash(mkdir *), Bash(grep *), Bash(jq *), Bash(date *), Bash(echo *), Bash(test *), Bash(for *), Bash(if *)
---

`ci-cd-pipeline` 스킬의 지침에 따라 아래 작업을 수행하라.

인자: $ARGUMENTS

- 인자 없음 → 실제 이슈 생성 (프로젝트 루트에 `cicd-issues.md`가 없어야 실행됨)
- `--dry-run` → GitHub 이슈를 실제 생성하지 않고 환경 감지 표 + 생성 예정 이슈 목록만 출력
- `--force` → `cicd-issues.md`가 이미 있어도 강제 재생성 (중복 이슈 생성 위험이 있으므로 실행 전 사용자에게 확인)
