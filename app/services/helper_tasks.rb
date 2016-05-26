class HelperTasks
  require 'csv'

  def self.schools_json
    text = File.read('db/data/schools.csv')
    rows = CSV.new(text, headers: true).to_a.map(&:to_hash)
    schools_array = rows.each_with_object([]) do |row, array|
      str = row['HD2014.ZIP code'].blank? ? "#{row['institution name']}" : "#{row['institution name']} (#{row['HD2014.ZIP code']})"
      array.push(str)
    end
    File.write('app/assets/data/schools.json', schools_array.uniq.to_json)
  end

  def self.seed_schools
    School.destroy_all
    text = File.read('db/data/schools.csv')
    rows = CSV.new(text, headers: true).to_a.map(&:to_hash)
    rows.each do |r|
      puts "Created record #{r['institution name']}"
      name = r['HD2014.ZIP code'].blank? ? "#{r['institution name']}" : "#{r['institution name']} (#{r['HD2014.ZIP code']})"
      params = {
        name: name,
        display_name: "#{r['institution name']}",
        code: r['unitid']
      }
      School.create(params)
    end
  end
end
