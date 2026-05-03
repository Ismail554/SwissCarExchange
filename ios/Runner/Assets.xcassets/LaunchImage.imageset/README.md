# Launch Image Assets (iOS)

This directory contains the launch image assets for the iOS target of the Rionydo application. These assets are displayed immediately when the app is launched while the Flutter engine is initializing.

## Assets Specification

To ensure a high-quality launch experience across all iOS devices, please provide images in the following resolutions:

| Scale | Filename | Description |
|-------|----------|-------------|
| 1x    | `LaunchImage.png` | Standard resolution |
| 2x    | `LaunchImage@2x.png` | High resolution (Retina) |
| 3x    | `LaunchImage@3x.png` | Ultra-high resolution (Retina HD) |

> [!IMPORTANT]
> iOS utilizes these images within the `LaunchScreen.storyboard`. For the best results, use centered logos with a solid background color that matches your app's initial theme.

## How to Update

### Using Xcode (Recommended)
1. Open the project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. In the Project Navigator, select `Runner` > `Assets.xcassets`.
3. Locate `LaunchImage` in the sidebar.
4. Drag and drop your new assets into the 1x, 2x, and 3x slots.

### Manual Replacement
Replace the `.png` files in this directory with your new assets. Ensure the filenames match exactly and follow the `@2x` and `@3x` suffix convention as defined in `Contents.json`.

## Best Practices
- **Branding**: Keep your logo or primary branding within the "Safe Area" to prevent clipping on devices with notches or rounded corners.
- **Background**: Use a background color consistent with the first frame of your Flutter app to provide a seamless transition.
- **File Size**: Optimize images to keep the initial app bundle size small and ensure fast loading.

---
*Documentation updated to support Rionydo project standards.*