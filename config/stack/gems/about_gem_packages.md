Sprinkle packages for gems
--------------------------

**Why write packages for gems, which are themselves packages?**
Because they often have system-level dependencies, which the gemspec doesn't 
document. This lets us document them and install their dependencies during
the initial stack install.

**Why do they have names like *_gem.rb?**
This differentiates them from the gem's own files. If you try to require
something like "bundler", you'll get a warning about it not
having a package definition for "bundler", because it's loaded the Bundler
class, not your package file.