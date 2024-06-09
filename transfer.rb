# read file

# parse file into entries
def parse_ohlife_export


end


def import_into_dayone(journal: "OhLife", timezone: "America/New_York")

    # Ex. 2015-06-01 15:53:10
    entry_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")

    puts "journal: #{journal}"
    puts "timezone: #{timezone}"
    puts "entry_date: #{entry_date}"

    entry_text = "foo bar"
    
    cmd = "dayone2 --journal='#{journal}' --time-zone='#{timezone}' --date='#{entry_date}' new #{entry_text}"
    %x[ #{cmd} ]
end

import_into_dayone()