module GoogleApi
  class Cache
    
    def initialize
      @cache = {}
    end

    def write(key, value, expire = 0)
      expire = expire == 0 ? 0 : Time.now + (expire * 60)

      @cache[key] = [value, expire]
    end

    def read(key)
      if exists?(key)
        return @cache[key][0]
      end

      nil
    end

    def exists?(key)
      @cache.has_key?(key) && !expire?(key)
    end

    def delete(key)
      @cache.delete(key)
    end

    private

      def expire?(key)
        expire = @cache[key][1]

        if expire == 0
          return false
        end

        if expire < Time.now
          delete(key)

          return true
        end

        false
      end

  end
end
