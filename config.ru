require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use AuthorsController
use BooksController
use GenresController
use PublishersController
run ApplicationController
