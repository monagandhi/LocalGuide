# Tungsten will define classes like User, expecting an app-specific redefinition later.
# For some reason, Rails will not load app/models/user.rb on its own if User is already defined.
# Force it to read User and other classes manually in this initializer.

require 'user'
