require_relative 'database_query'

class Recipe
  attr_reader :id, :name
  def initialize(recipe)
    @id = recipe['id']
    @name = recipe['name']
    @recipe = recipe
  end

  def self.all
    query = "SELECT * FROM recipes ORDER BY name"

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
                  recipes.instructions,
                  ingredients.name AS ingredient
             FROM recipes
             JOIN ingredients ON recipes.id = ingredients.recipe_id
             WHERE recipes.id = $1'

    DatabaseQuery.db_connection do |conn|
      recipe = conn.exec(query, [id])
      recipe = recipe.to_a
      recipe_info = {'id'=>recipe[0]['id'],
                     'name'=>recipe[0]['name'],
                     'description'=>recipe[0]['description'],
                     'instructions'=>recipe[0]['instructions']}
      ingredients = []
      recipe.each {|ingredient| ingredients << ingredient['ingredient']}
      recipe_info['ingredients'] = ingredients
      Recipe.new(recipe_info)
    end
  end

  def description
    @description = @recipe['description']
    if @description == nil
      "This recipe doesn't have a description."
    else
      @description
    end
  end

  def instructions
    @instructions = @recipe['instructions']
    if @instructions == nil
      "This recipe doesn't have any instructions."
    else
      @instructions
    end
  end

  def ingredients
    @ingredients = @recipe['ingredients']
    ingredients_new = []
    @ingredients.each do |ingredient|
      ingredients_new << Ingredient.new(ingredient)
    end
    ingredients_new
  end
end
