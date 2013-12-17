# -*- encoding : utf-8 -*-

# Read a MD file and update the Page-model
class StaticPageUpdateService

  # Read markdown-files from the project's root-path and
  # import them to the Page-model. Update the body if a page exists.
  # @param [String] _file absolute path to markdown-file
  def initialize _file
    _title = title_of_md_file _file
    page = find_or_create_page _title, _file
    update_page_from_file( page, _file )
  end

  private

  def update_page_from_file( page, file )
    _text = File.read file
    if page.body != _text
      page.update_attributes(
        draft: false,
        body: _text,
        created_at: File.ctime(file),
        updated_at: File.mtime(file)
      )
    end
  end

  def find_or_create_page _title, file
    Page.where(title: _title.upcase).first || Page.create( title: _title.upcase, updated_at: File.mtime(file) )
  end

  def title_of_md_file _file
    File.basename(_file, '.md')
  end

end

