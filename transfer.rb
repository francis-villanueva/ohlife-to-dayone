# read file

# parse file into entries
def parse_ohlife_export

    export_text = File.read('./content/sample.txt')

    # based on
    # https://stackoverflow.com/questions/63628329/splitting-multiline-string-into-groups-based-on-a-regex-pattern
    # Regex101 test: https://regex101.com/r/m6jMhE/1
    parsed_entries = export_text.scan(/^\d.*(?:\r?\n(?!\d{4}\-(?:0[1-9]|1[012])\-(?:0[1-9]|[12][0-9]|3[01])\n\n).*)*/)

    puts "Found #{parsed_entries.size} entries"
    parsed_entries[0..0].each do |entry|
        import_into_dayone(
            entry_date: entry.match(/^\d{4}\-(?:0[1-9]|1[012])\-(?:0[1-9]|[12][0-9]|3[01])\n\n/), 
            entry_text: entry.gsub!(/^\d{4}\-(?:0[1-9]|1[012])\-(?:0[1-9]|[12][0-9]|3[01])\n\n/, '')
        )
    end
end


def import_into_dayone(journal: "OhLife", timezone: "America/New_York", entry_date: nil, entry_text: "")
    return false if entry_date.nil? || entry_text.empty?

    # Ex. 2015-06-01 15:53:10 using NOW
    # entry_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")

    puts "journal: #{journal}"
    puts "timezone: #{timezone}"
    puts "entry_date: #{entry_date}"
    puts "entry_text: #{entry_text}"
    
    import_cmd = "entry=\"#{entry_text}\" && dayone2 --journal='#{journal}' --time-zone='#{timezone}' --date='#{entry_date}' new $entry"
    %x[ #{import_cmd} ]
end

parse_ohlife_export()