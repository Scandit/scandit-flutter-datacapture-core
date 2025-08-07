def podspec_path_for_pod(pod_name, current_path)
    # the current_path will be always the folder of the Podfile where this function is executed
    current_dir = File.expand_path(current_path)
    while current_dir != '/' do
        frameworks_path = File.join(current_dir, 'frameworks')
        if File.exist?(frameworks_path)
            return File.join(frameworks_path, 'shared', 'ios', pod_name)
        end
        current_dir = File.dirname(current_dir)
    end
    # Fallback if no frameworks directory is found
    File.join(current_path.split('data-capture-sdk')[0], 'data-capture-sdk', 'frameworks', 'shared', 'ios', pod_name)
end

