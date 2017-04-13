task :stats => "dpapi:statsetup"
namespace :dpapi do
  desc 'Add more folders to stats'
  task :statsetup do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << ["Services", "app/services"]

    # For test folders not defined in CodeStatistics::TEST_TYPES (ie: spec/)
    # ::STATS_DIRECTORIES << ["Services specs", "specs/services"]
    # CodeStatistics::TEST_TYPES << "Services specs"
  end
end