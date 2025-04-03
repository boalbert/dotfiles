# Functions file for Fish shell
# Save this as ~/.config/fish/functions/gsb.fish

function gsb --description "Git smart branches: shows branches sorted by last checkout time"
    # Check if in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "Error: Not in a git repository"
        return 1
    end

    # Function to get the last checkout time for a branch
    function __gsb_get_last_checkout_time
        set branch $argv[1]

        # Look through reflog for the last time this branch was checked out
        set timestamp (git reflog --date=iso | grep -E "checkout: moving from .* to $branch" | head -n 1 | string replace -r '^[^{]*\{([^}]*)\}.*$' '$1')

        if test -z "$timestamp"
            # If no checkout found in reflog, use branch creation time as fallback
            set timestamp (git log -1 --format=%cd --date=iso $branch 2>/dev/null)
        end

        echo $timestamp
    end

    # Function to get the latest commit message for a branch
    function __gsb_get_latest_commit_message
        set branch $argv[1]
        set message (git log -1 --pretty=format:"%s" $branch 2>/dev/null)

        # Truncate message if too long
        if test (string length "$message") -gt 50
            set message (string sub -l 47 "$message")"..."
        end

        echo $message
    end

    # Get all branches
    set branches (git branch --format="%(refname:short)")

    # Create temporary file to store branch info
    set temp_file (mktemp)

    # Get information for each branch
    for branch in $branches
        set last_checkout (__gsb_get_last_checkout_time "$branch")
        set commit_message (__gsb_get_latest_commit_message "$branch")

        if test -n "$last_checkout"
            # Format: timestamp|branch_name|commit_message (for sorting)
            echo "$last_checkout|$branch|$commit_message" >> $temp_file
        end
    end

    # Sort branches by checkout time (newest first)
    set sorted_branches (sort -r $temp_file)

    # Column widths
    set branch_width 35
    set date_width 19
    set msg_width 50

    # Get terminal width to adjust message column if needed
    set term_width (tput cols)
    if test $term_width -gt 0
        # Calculate available space for message column
        set available_width (math $term_width - $branch_width - $date_width - 7) # 7 for separators and spacing
        if test $available_width -gt 20 # Ensure at least 20 chars for message
            set msg_width $available_width
        end
    end

    # Display header
    set_color blue
    printf "%-"$branch_width"s | %-"$date_width"s | %s\n" "BRANCH" "LAST CHECKED OUT" "LATEST COMMIT"
    printf "%-"$branch_width"s | %-"$date_width"s | %s\n" (string repeat -n $branch_width "-") (string repeat -n $date_width "-") (string repeat -n $msg_width "-")
    set_color normal

    # Current branch
    set current_branch (git branch --show-current)

    # Display branch information
    for branch_data in $sorted_branches
        # Split the data
        set parts (string split "|" $branch_data)
        set timestamp $parts[1]
        set branch $parts[2]
        set commit_message $parts[3]

        # Format date more nicely if it exists
        if test -n "$timestamp"
            # Fish doesn't have date -d, so we use a more portable approach
            set formatted_date (string replace -r "^([0-9]{4}-[0-9]{2}-[0-9]{2}) ([0-9]{2}:[0-9]{2}).*" '$1 $2' "$timestamp")
            if test $status -ne 0
                # If formatting fails, just use the original timestamp
                set formatted_date $timestamp
            end
        else
            set formatted_date "unknown"
        end

        # Prepare branch display name (with or without asterisk)
        set branch_display $branch
        if test "$branch" = "$current_branch"
            set branch_display "$branch *"
        end

        # Truncate branch name if too long
        if test (string length "$branch_display") -gt (math $branch_width - 2)
            set branch_display (string sub -l (math $branch_width - 5) "$branch_display")"..."
        end

        # Highlight current branch
        if test "$branch" = "$current_branch"
            set_color green
            printf "%-"$branch_width"s | " "$branch_display"
            set_color normal
        else
            printf "%-"$branch_width"s | " "$branch_display"
        end

        # Truncate commit message if needed
        if test (string length "$commit_message") -gt $msg_width
            set commit_message (string sub -l (math $msg_width - 3) "$commit_message")"..."
        end

        printf "%-"$date_width"s | %s\n" "$formatted_date" "$commit_message"
    end

    # Clean up
    rm $temp_file

    # Functions defined within the main function are automatically erased when it completes
end
