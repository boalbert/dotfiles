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

    # Display header
    set_color blue
    printf "%-30s | %-19s | %s\n" "BRANCH" "LAST CHECKED OUT" "LATEST COMMIT"
    printf "%-30s | %-19s | %s\n" (string repeat -n 30 "-") (string repeat -n 19 "-") (string repeat -n 50 "-")
    set_color normal

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

        # Highlight current branch
        if test "$branch" = (git branch --show-current)
            set_color green
            printf "%-30s | " "$branch *"
            set_color normal
        else
            printf "%-30s | " "$branch"
        end

        printf "%-19s | %s\n" "$formatted_date" "$commit_message"
    end

    # Clean up
    rm $temp_file

    # Functions defined within the main function are automatically erased when it completes
end
