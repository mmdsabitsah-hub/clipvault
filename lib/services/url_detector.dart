/// Identifies what kind of link the user pasted. This does NOT fetch or
/// bypass anything - it only classifies the URL so the UI can explain
/// what ClipVault can and cannot do with it.
enum MediaPlatform {
  directFile,
  youtube,
  instagram,
  facebook,
  tiktok,
  x,
  vimeo,
  other,
  invalid,
}

class DetectionResult {
  const DetectionResult({
    required this.platform,
    required this.label,
    required this.canDownloadDirectly,
    required this.message,
    this.uri,
  });

  final MediaPlatform platform;
  final String label;
  final bool canDownloadDirectly;
  final String message;
  final Uri? uri;
}

class UrlDetector {
  static const _mediaExtensions = {
    'mp4', 'mkv', 'webm', 'mov', 'avi', 'm4v', '3gp',
    'mp3', 'm4a', 'aac', 'wav', 'flac', 'ogg', 'opus',
    'jpg', 'jpeg', 'png', 'gif', 'webp',
  };

  static const _restricted = <MediaPlatform, List<String>>{
    MediaPlatform.youtube: ['youtube.com', 'youtu.be'],
    MediaPlatform.instagram: ['instagram.com'],
    MediaPlatform.facebook: ['facebook.com', 'fb.watch'],
    MediaPlatform.tiktok: ['tiktok.com'],
    MediaPlatform.x: ['twitter.com', 'x.com'],
    MediaPlatform.vimeo: ['vimeo.com'],
  };

  static const _names = {
    MediaPlatform.youtube: 'YouTube',
    MediaPlatform.instagram: 'Instagram',
    MediaPlatform.facebook: 'Facebook',
    MediaPlatform.tiktok: 'TikTok',
    MediaPlatform.x: 'X (Twitter)',
    MediaPlatform.vimeo: 'Vimeo',
  };

  static DetectionResult detect(String input) {
    final text = input.trim();
    final uri = Uri.tryParse(text);
    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty ||
        !uri.host.contains('.')) {
      return const DetectionResult(
        platform: MediaPlatform.invalid,
        label: 'Not a valid link',
        canDownloadDirectly: false,
        message: 'Enter a full http(s) link, for example https://example.com/video.mp4',
      );
    }

    final host = uri.host.toLowerCase();
    for (final entry in _restricted.entries) {
      if (entry.value.any((d) => host == d || host.endsWith('.$d'))) {
        final name = _names[entry.key]!;
        return DetectionResult(
          platform: entry.key,
          label: name,
          canDownloadDirectly: false,
          uri: uri,
          message: '$name was recognised, but ClipVault does not download from it. '
              'The platform does not offer an authorised download API for this link, and '
              'ClipVault will not bypass its terms, logins or protections. '
              'Use the platform\'s own save/offline feature, or a link you are '
              'authorised to download directly.',
        );
      }
    }

    final path = uri.path.toLowerCase();
    final dot = path.lastIndexOf('.');
    final ext = dot >= 0 ? path.substring(dot + 1) : '';
    if (_mediaExtensions.contains(ext)) {
      return DetectionResult(
        platform: MediaPlatform.directFile,
        label: 'Direct .${ext.toUpperCase()} file',
        canDownloadDirectly: true,
        uri: uri,
        message: 'This looks like a direct media file on ${uri.host}. '
            'Size and format details will be read from the server\'s response '
            'headers once the download engine is added (Stage 4-5).',
      );
    }

    return DetectionResult(
      platform: MediaPlatform.other,
      label: uri.host,
      canDownloadDirectly: false,
      uri: uri,
      message: 'ClipVault could not identify a direct media file at this link. '
          'If you are authorised to download from this site, paste the direct file URL.',
    );
  }
}
