# cloudflare-rails 7.0 keeps Cloudflare's IP ranges for the life of the process
# once a download succeeds, and downloads them again on every request while a
# download fails. This bounds both. A downloaded list is refreshed after twelve
# hours. After a failed download the last good list (or the one bundled with
# the gem) is served for five minutes before the next attempt.
module CloudflareRangeRefresh
  REFRESH_AFTER = 12.hours
  RETRY_AFTER = 5.minutes

  def cloudflare_ips(refresh: false)
    return @ranges if @ranges && !refresh && Time.current < @ranges_stale_at

    downloaded = super(refresh: true)

    # The gem assigns @ips only when the download succeeded; on failure it
    # returns its bundled list and leaves @ips empty.
    if @ips
      @ranges = downloaded
      @ranges_stale_at = REFRESH_AFTER.from_now
    else
      @ranges ||= downloaded
      @ranges_stale_at = RETRY_AFTER.from_now
    end

    @ranges
  end
end

CloudflareRails::Importer.singleton_class.prepend(CloudflareRangeRefresh)
