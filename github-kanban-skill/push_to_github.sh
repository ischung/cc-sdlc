#!/bin/bash
# ============================================================
# github-kanban-skill → GitHub 업로드 스크립트
# 사용법: bash push_to_github.sh
# ============================================================

GITHUB_USER="ischung"
REPO_NAME="github-kanban-skill"

echo ""
echo "=================================================="
echo "  GitHub Kanban Skill → GitHub 업로드"
echo "=================================================="
echo ""

# 현재 폴더 확인
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
echo "📁 작업 폴더: $SCRIPT_DIR"
echo ""

# git 초기화 (이미 .git이 있으면 스킵)
if [ ! -d ".git" ]; then
  git init
  git branch -m master main
  git config user.name "$GITHUB_USER"
  echo "✅ git 초기화 완료"
fi

# 커밋이 없으면 커밋 생성
if ! git log --oneline -1 > /dev/null 2>&1; then
  git add .
  git commit -m "Initial commit: github-kanban-skill for Claude"
  echo "✅ 커밋 생성 완료"
fi

# GitHub 저장소 생성 (gh CLI가 있는 경우)
if command -v gh &> /dev/null; then
  echo "🔧 GitHub 저장소 생성 중..."
  gh repo create "$REPO_NAME" --public --description "Claude용 GitHub Projects 칸반 보드 자동 생성 스킬" --source . --remote origin --push
  echo ""
  echo "=================================================="
  echo "✅ 업로드 완료!"
  echo "🔗 https://github.com/$GITHUB_USER/$REPO_NAME"
  echo "=================================================="
else
  # gh CLI가 없는 경우 — git push 방법 안내
  echo "⚠️  gh CLI가 없습니다. 아래 순서로 진행하세요:"
  echo ""
  echo "  1. https://github.com/new 에서 저장소 생성:"
  echo "     - Repository name: $REPO_NAME"
  echo "     - Public 선택"
  echo "     - 'Add a README file' 체크 해제"
  echo "     - [Create repository] 클릭"
  echo ""
  echo "  2. 아래 명령어를 이 터미널에 붙여넣기:"
  echo ""
  echo "     git remote add origin https://github.com/$GITHUB_USER/$REPO_NAME.git"
  echo "     git branch -M main"
  echo "     git push -u origin main"
  echo ""
fi
