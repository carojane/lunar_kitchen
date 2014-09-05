require_relative 'database_query'

class Recipe
  attr_reader :id, :name
  def initialize(recipe)
    @id = recipe['id']
    @name = recipe['name']
    @recipe = recipe
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

  def self.find(id)
    query = 'SELECT recipes.id,
                  recipes.name,
                  recipes.description,
                  recipes.instructions
             FROM recipes
             WHERE recipes.id = $1'

    DatabaseQuery.db_connection do |conn|
      recipe = conn.exec(query, [id])
      Recipe.new(recipe[0])
    end
  end

  def description
    @description = @recipe['description']
  end
  def instructions
    @instructions = @recipe['instructions']
  end
  def ingredients
    []
  end
end
