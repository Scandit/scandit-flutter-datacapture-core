def podspec_path_for_pod(pod_name, current_path)
    # the current_path will be always the folder of the Podfile where this function is executed
    archive_dir = File.expand_path(File.join('..', '..', '..'))
    if File.exist?(File.join(archive_dir, 'frameworks'))
        File.join(archive_dir, 'frameworks', 'shared', 'ios', pod_name)
    else
        File.join(current_path.split('data-capture-sdk')[0], 'data-capture-sdk', 'frameworks', 'shared', 'ios', pod_name)
    end
end