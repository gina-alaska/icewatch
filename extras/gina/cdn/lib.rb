module GINA
  module CDN
    class Lib
      def initialize(name, v=nil)
         @lib = ::GINA::LIBS[name]
         self.version = v
      end

      def js
        files[:js].collect { |f| f.gsub('{version}', version) }
      end

      def css
        files[:css].collect { |f| f.gsub('{version}', version) }
      end

      def version=(v)
        if v.nil?
          @version = versions[:default]
        elsif v == :beta
          @version = versions[:beta] 
        else
          @version = v
        end
      end

      def version
        @version
      end

      protected
      def versions
        @lib[:versions]
      end

      def files
        @lib[Rails.env.to_sym]
      end
    end
  end
end
