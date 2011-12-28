# Monkey-patch so we can reference capistrano variables (stage, user, deploy_to, etc)
# in our packages.
#
# You'll need to add this to your capistrano recipes:
#   Sprinkle::Package::Package.set_variables = self.variables
# and then you can reference variables from packages with:
#   Package.fetch(:variable_name)
#
module Sprinkle::Package
 class Package
   @@capistrano = {}

   def self.set_variables=(set)
     @@capistrano = set
   end

   def self.fetch(name)
     @@capistrano[name]
   end

   def self.exists?(name)
     @@capistrano.key?(name)
   end
 end
end