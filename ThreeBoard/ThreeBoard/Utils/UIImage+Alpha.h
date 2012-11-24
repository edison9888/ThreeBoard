// UIImage+Alpha.h
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Helper methods for adding an alpha layer to an image
@interface UIImage (Alpha)
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
@end



//[code]
//// Create paths to output images
//NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
//NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
//
//// Write a UIImage to JPEG with minimum compression (best quality)
//// The value 'image' must be a UIImage object
//// The value '1.0' represents image compression quality as value from 0.0 to 1.0
//[UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
//
//// Write image to PNG
//[UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
//
//// Let's check to see if files were successfully written...
//
//// Create file manager
//NSError *error;
//NSFileManager *fileMgr = [NSFileManager defaultManager];
//
//// Point to Document directory
//NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//
//// Write out the contents of home directory to console
//NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
//[/code][code]
//// Create paths to output images
//NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
//NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
//
//// Write a UIImage to JPEG with minimum compression (best quality)
//// The value 'image' must be a UIImage object
//// The value '1.0' represents image compression quality as value from 0.0 to 1.0
//[UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
//
//// Write image to PNG
//[UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
//
//// Let's check to see if files were successfully written...
//
//// Create file manager
//NSError *error;
//NSFileManager *fileMgr = [NSFileManager defaultManager];
//
//// Point to Document directory
//NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//
//// Write out the contents of home directory to console
//NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
//[/code]