def sort_birds(page, birds, max_elements, &block)
  birds = birds.sort_by {|bird| [bird[:common_name].split.last, bird[:common_name].split.first]}

  first_element = (page - 1) * max_elements
  
  current_birds = birds[first_element, max_elements]

  current_birds.each(&block)
end

def create_pages(page, size, max_elements, &block)
  last_page = (size / max_elements.to_f).ceil
  pages = (1..last_page).to_a

   pages.each(&block) if pages.size > 1
end