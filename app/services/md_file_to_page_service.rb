# -*- encoding : utf-8 -*-

# Read a MD file and update the Page-model
class MdFileToPageService

  # @param [String] _file absolute path to markdown-file
  def initialize _file
    _title, _text = read_md_file(_file)
    page = find_or_create_page _title, _file
    update_page_from_file( page, _text, _file )
  end

  private

  def update_page_from_file( page, _text, file )
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
    Page.find(_title) || Page.create( title: _title.upcase, updated_at: File.mtime(file) )
  end

  def read_md_file(file)
    [ title_of_md_file(file), File.read(file) ]
  end

  def title_of_md_file _file
    File.basename(_file, '.md')
  end

end

