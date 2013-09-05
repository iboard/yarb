# -*- encoding : utf-8 -*-"


# Touch the spec-file if the source covered by the spec is modified
# after spec's mtime.
# @param [String] source - the source-file relative to app's root
# @param [String] specfile - the spec covering the source - relative to spec/
# @return [Boolean] true if source file is 'younger' than the spec file
def cover_source_by source, specfile
  _source = File.expand_path( "../../../#{source}", __FILE__ )
  _spec   = File.expand_path("../../#{specfile}", __FILE__)
  FileUtils.touch(_spec) if File.mtime(_source) > File.mtime(_spec)
  File.mtime(_source) <= File.mtime(_spec)
end

