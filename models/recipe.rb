require_relative 'database_query'

class Recipe
  attr_reader :id, :name
  def initialize(recipe)
    @id = recipe['id']
    @name = recipe['name']
  end

  def self.all
    query = "SELECT * FROM recipes"

    all_recipes = []
    DatabaseQuery.db_connection do |conn|
      conn.exec(query).each do |recipe|
        all_recipes << Recipe.new(recipe)
      end
    end
    all_recipes
  end
end
