task schools_json: :environment do
  HelperTasks.schools_json
  HelperTasks.seed_schools
end
