//
//  Copyright (c) 2014 Optimizely. All rights reserved.
//

@interface OptimizelyFileManager : NSObject {
    NSFileManager *_fm;
}

@property (readonly) NSString *assetsDirectory;
@property (readonly) NSString *baseDirectory;
@property (readonly) NSString *databaseFilePath;
@property (readonly) NSString *dataFilePath;
@property (readonly) NSString *dataFileTempPath;
@property (readonly) NSString *previewFilePath;

- (BOOL)assetFileExists:(NSString*)filename;
- (BOOL)dataFileExists;
- (BOOL)dataFileTempExists;
- (BOOL)previewFileExists;
- (BOOL)databaseFileExists;

- (NSString*)pathForAsset:(NSString*)filename;
- (NSArray*)savedAssets;

- (void)removeAllFiles;
- (void)removeAsset:(NSString*)filename;
- (void)removePreviewFiles;
- (void)removeDataFileTemp;
- (void)removeDataFile;

@end
