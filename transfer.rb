# import required classes
require 'time'

# parse file into entries
def parse_ohlife_export

  # read file
  export_text = File.read('./content/sample.txt')

  # based on
  # https://stackoverflow.com/questions/63628329/splitting-multiline-string-into-groups-based-on-a-regex-pattern
  # Regex101 test: https://regex101.com/r/m6jMhE/1
  parsed_entries = export_text.scan(/^\d.*(?:\r?\n(?!\d{4}\-(?:0[1-9]|1[012])\-(?:0[1-9]|[12][0-9]|3[01])\n\n).*)*/)
  parsed_entries_count = parsed_entries.size
  entries_imported_count = 0

  puts "Found #{parsed_entries_count} entries"
  parsed_entries.each do |entry|
    imported = import_into_dayone(
        entry_date: entry.match(/^\d{4}\-(?:0[1-9]|1[012])\-(?:0[1-9]|[12][0-9]|3[01])\n\n/)[0].strip,
        entry_text: entry.gsub!(/^\d{4}\-(?:0[1-9]|1[012])\-(?:0[1-9]|[12][0-9]|3[01])\n\n/, '').strip
    )

    entries_imported_count += 1 if imported
  end

  puts "Import complete! #{entries_imported_count} entries imported: #{calculate_percent(entries_imported_count, parsed_entries_count)}%"
end

# call out to the DayOne CLI and import the entry
def import_into_dayone(journal: "OhLife", timezone: "America/New_York", entry_date: nil, entry_text: "")
  if entry_date.nil? || entry_text.empty?
    puts "\t Skipping entry..."
    return false
  else
    # Ex. 2015-06-01 15:53:10 using NOW
    # entry_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")

    # modify entry to account for timezone
    # entry_date += "T23:59:00Z -4:00"

    # puts "journal: #{journal}"
    # puts "timezone: #{timezone}"
    puts "entry_date: #{entry_date}"
    # puts "entry_text: #{entry_text}"
    
    import_cmd = "entry=\"#{entry_text}\" && dayone2 --journal='#{journal}' --time-zone='#{timezone}' --date='#{entry_date}' new \"$entry\""
    %x[ #{import_cmd} ]
    return true
  end
end

# return a percentage rounded to 2 decimal places
def calculate_percent(part, total)
  ((part.to_f / total.to_f) * 100.0).round(2)
end

parse_ohlife_export()