# Create a singleton that holds a Redis Connection pool.
# The with method allows you to pass a block to this pool
class RedisPool
	include Singleton
	@redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new }

	def self.with(&block)
		@redis.with(&block)
	end
end
