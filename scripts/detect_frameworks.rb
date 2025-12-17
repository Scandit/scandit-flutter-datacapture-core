require 'pathname'

def podspec_path_for_pod(pod_name, current_path)
    podfile_dir = File.expand_path(current_path)
    current_dir = podfile_dir
    while current_dir != '/' do
        if File.basename(current_dir) == 'frameworks'
            frameworks_dir = current_dir
            pod_path = File.join(frameworks_dir, 'shared', 'ios', pod_name)
            relative_path = Pathname.new(pod_path).relative_path_from(Pathname.new(podfile_dir))
            return relative_path.to_s
        end
        current_dir = File.dirname(current_dir)
    end

    if podfile_dir.include?('data-capture-sdk')
        base_path = podfile_dir.split('data-capture-sdk')[0]
        pod_path = File.join(base_path, 'data-capture-sdk', 'frameworks', 'shared', 'ios', pod_name)
        relative_path = Pathname.new(pod_path).relative_path_from(Pathname.new(podfile_dir))
        return relative_path.to_s
    else
        raise "Could not find 'frameworks' directory and fallback also failed."
    end
end

