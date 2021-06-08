module Mint
  class Ast
    module Directives
      class Svg < Node
        getter real_path : Path
        getter path

        def initialize(@path : String,
                       @input : Data,
                       @from : Int32,
                       @to : Int32)
          @real_path = expand_asset_path(input, path)
        end

        def exists?
          File.exists?(real_path)
        end

        def file_contents : String
          File.read(real_path)
        end

        def expand_asset_path(input, path) : Path
          if path.starts_with?(ASSET_DIR_ALIAS)
            asset_path = path[ASSET_DIR_ALIAS.size..]
  
            normalized_path = if asset_path[0] == '/'
              asset_path
            else
              "/#{asset_path}"
            end
  
            Path["#{Dir.current}/#{ASSET_DIR}#{normalized_path}"]
          else
            Path[input.file].sibling(path).expand
          end
        end
      end
    end
  end
end
