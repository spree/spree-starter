# libvips keeps the last 100 operations and their images (up to 100 MB) for
# reuse. Image variants are resized once and stored, so the cache only adds
# memory to every job process. On a dedicated job worker, also run each resize
# on one thread (VIPS_CONCURRENCY=1): concurrent resizes already use one job
# thread each, and a second level of parallelism only multiplies the buffers
# in memory.
#
# Where libvips isn't installed (a CI runner, an app that never resizes
# images), there is nothing to configure, and booting must not depend on it.
begin
  require 'vips'
  Vips.cache_set_max(0)
rescue LoadError
  nil
end

# Each resize leaves a few MB that only a full garbage collection frees, and
# Ruby rarely runs one: libvips allocates outside the Ruby heap, so Ruby never
# sees the pressure. Loading sample data (about 750 resizes) grew the image
# worker to 3.6 GB without this, and kept it near 0.5 GB with it, at the cost
# of slower resizes.
Rails.application.config.to_prepare do
  ActiveStorage::TransformJob.after_perform { GC.start }
end
