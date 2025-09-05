#!/usr/bin/env zsh
# GitHub CLI Configuration & Workflow Functions

# ============================================================
# WORKFLOW FUNCTIONS (핵심 워크플로우)
# ============================================================

# 브랜치 삭제 (FZF 다중 선택)
gbdel() {
    local BRANCHES=$(git branch | grep -v '^\*' | \
      fzf --multi --reverse --header="Select branches to delete (Tab to select, Enter to confirm):")
    
    if [ -n "$BRANCHES" ]; then
      echo "🗑️ Selected branches to delete:"
      echo "$BRANCHES"
      echo -n "Confirm deletion? (y/N) "
      read -r REPLY
      
      if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        echo "$BRANCHES" | while read -r BRANCH; do
          BRANCH=$(echo "$BRANCH" | xargs)
          echo "Deleting: $BRANCH"
          git branch -D "$BRANCH" 2>/dev/null || git branch -d "$BRANCH"
        done
        echo "✅ All selected branches deleted!"
      else
        echo "❌ Cancelled"
      fi
    fi
}

# 🌟 대화형 워크플로우 통합 함수 (권장)
ghwork() {
    local GH_USER="hoetaek"
    
    # 1. 이슈 선택
    ISSUE=$(PAGER='' gh issue list -a "$GH_USER" --json number,title -q '.[] | "\(.number) \(.title)"' | \
        fzf --reverse --header="Select issue to work on:" | awk '{print $1}')
    
    if [ -z "$ISSUE" ]; then
        echo "No issue selected"
        return 1
    fi
    
    # 2. 브랜치 존재 확인
    EXISTING_BRANCH=$(gh issue develop --list "$ISSUE" 2>/dev/null | head -n 1 | cut -f1)
    
    if [ -n "$EXISTING_BRANCH" ]; then
        echo "✓ Branch already exists: $EXISTING_BRANCH"
        read "REPLY?Checkout existing branch? (Y/n) "
        if [[ ! "$REPLY" =~ ^[Nn]$ ]]; then
            git checkout -B "$EXISTING_BRANCH" "origin/$EXISTING_BRANCH" 2>/dev/null || \
                git checkout "$EXISTING_BRANCH"
            return 0
        fi
        echo "Creating new branch instead..."
    fi
    
    # 3. 베이스 브랜치 선택
    echo "Issue #$ISSUE needs a new branch. Select base:"
    CURRENT_BRANCH=$(git branch --show-current)
    
    BASE_OPTIONS="develop - Default branch\nfeatures/k-monitoring - K-monitoring feature\ncurrent ($CURRENT_BRANCH) - Continue from current\nfrom-issue - Base on another issue's branch"
    
    BASE_CHOICE=$(echo -e "$BASE_OPTIONS" | \
        fzf --reverse --header="Select base branch for issue #$ISSUE:" | awk '{print $1}')
    
    if [ -z "$BASE_CHOICE" ]; then
        echo "No base branch selected"
        return 1
    fi
    
    # 4. 브랜치 생성
    case $BASE_CHOICE in
        develop)
            gh issue develop "$ISSUE" --checkout
            ;;
        features/k-monitoring)
            gh issue develop --base "features/k-monitoring" "$ISSUE" --checkout
            ;;
        current)
            gh issue develop --base "$CURRENT_BRANCH" "$ISSUE" --checkout
            ;;
        from-issue)
            BASE_ISSUE=$(PAGER='' gh issue list -a "$GH_USER" --json number,title -q '.[] | "\(.number) \(.title)"' | \
                fzf --reverse --header="Select BASE issue:" | awk '{print $1}')
            
            if [ -z "$BASE_ISSUE" ]; then
                echo "No base issue selected"
                return 1
            fi
            
            BASE_BRANCH=$(gh issue develop --list "$BASE_ISSUE" 2>/dev/null | head -n 1 | cut -f1)
            if [ -z "$BASE_BRANCH" ]; then
                echo "Error: No branch found for issue #$BASE_ISSUE"
                return 1
            fi
            
            gh issue develop --base "$BASE_BRANCH" "$ISSUE" --checkout
            ;;
        *)
            echo "Unknown choice: $BASE_CHOICE"
            return 1
            ;;
    esac
}

# ============================================================
# QUICK BRANCH FUNCTIONS (빠른 브랜치 생성)
# ============================================================

# 기본 이슈 브랜치
ghdev() { gh issue develop "$1" --checkout }

# K-모니터링 브랜치
ghkmon() { gh issue develop --base "features/k-monitoring" "$1" --checkout }

# 현재 브랜치 기반
ghcr() {
    CURRENT_BRANCH=$(git branch --show-current)
    gh issue develop "$1" --base "$CURRENT_BRANCH" --checkout
}

# 이슈 간 연계 개발
ghfrom() {
    BASE_BRANCH=$(gh issue develop --list "$1" | head -n 1 | cut -f1)
    if [ -z "$BASE_BRANCH" ]; then
        echo "Error: No base branch found for issue #$1"
        return 1
    fi
    gh issue develop "$2" --base "$BASE_BRANCH" --checkout
}

# 이슈 베이스 브랜치로 체크아웃
coi() {
    BASE_BRANCH=$(gh issue develop --list "$1" | head -n 1 | cut -f1)
    if [ -z "$BASE_BRANCH" ]; then
        echo "Error: No base branch found for issue #$1"
        return 1
    fi
    git checkout "$BASE_BRANCH"
}

# ============================================================
# PR REVIEW FUNCTIONS (리뷰 관련)
# ============================================================

# 현재/선택한 PR의 Claude 리뷰 복사
prcc() {
    local PR_NUM=$(gh pr view --json number -q .number 2>/dev/null)
    
    if [ -z "$PR_NUM" ]; then
        PR_NUM=$(gh pr list --limit 30 | fzf --reverse | awk '{print $1}')
        [ -z "$PR_NUM" ] && return 1
    fi
    
    echo "Getting Claude review from PR #$PR_NUM..."
    local FULL=$(gh pr view $PR_NUM --json comments -q '.comments[].body')
    local RESULT=$(echo "$FULL" | sed -n '/개선/,$p')
    [ -z "$RESULT" ] && RESULT="$FULL"
    
    echo "$RESULT" | pbcopy
    echo "✅ Copied!"
}