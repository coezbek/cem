
#
# Christopher Flammarion extensions
#

return unless Gem.loaded_specs.has_key? 'flammarion'

require 'flammarion'

require "cem/cflame/missing_html"
require "cem/cflame/progress"
require "cem/cflame/p"
require "cem/cflame/clickable_img"
