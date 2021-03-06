projectname=$(basename $PWD)
echo $projectname

# sed -i "" "/Begin PBXContainerItemProxy section/,/End PBXContainerItemProxy section/d" ios/$projectname.xcodeproj/project.pbxproj
# sed -i "" "/Begin PBXReferenceProxy section/,/End PBXReferenceProxy section/d" ios/$projectname.xcodeproj/project.pbxproj
# sed -i "" "/projectReferences/,/);/d;/main.jsbundle/d" ios/$projectname.xcodeproj/project.pbxproj
# sed -i "" "/RCTActionSheet/d;/RCTGeolocation/d;/RCTAnimation/d;/RCTBlob/d;/RCTImage/d;/RCTLinking/d;/RCTNetwork/d;/RCTSettings/d;/RCTText/d;/RCTWebSocket/d;/RCTVibration/d;/libcxxreact/d;/libjschelpers/d;/libReact/d;/libyoga/d;/React.xcodeproj/d" ios/$projectname.xcodeproj/project.pbxproj

# sed -i "" "/main.jsbundle/d" ios/$projectname.xcodeproj/project.pbxproj

# sed -i "" "/\"react-native\":/d" package.json


sed -i '' '/"scripts"/a\'$'\n''"update": "yarn upgrade && cd ios && pod update",\'$'\n' package.json
sed -i '' '/"scripts"/a\'$'\n''"init": "yarn install --no-optional -s --registry=https://registry.npm.taobao.org && cd ios && pod install",\'$'\n' package.json
sed -i '' '/"init"/s/^/    /g;/"update"/s/^/    /g' package.json

rnSecondVersion=`sed -n "/\"react-native\"/s/[^0]*0\.\([1-9]*\).*/\1/p" package.json`
if [ $rnSecondVersion -gt 48 ]; then
  sed -i "" "/Yoga/s/Yoga/yoga/g" ios/Podfile
  if [ $rnSecondVersion -gt 53 ]; then
    sed -i "" "s/BatchedBridge/CxxBridge/g" ios/Podfile
    sed -i "" "s/jschelpers_legacy/jschelpers/g" ios/Podfile
    sed -i "" "s/cxxreact_legacy/cxxreact/g" ios/Podfile
  fi
fi

sed -i "" "/\'fego/s/fego/$projectname/g" ios/Podfile

sed -i "" "s/index.ios/index/g;s/fego/$projectname/g" ios/$projectname/AppDelegate.m

sed -i "" "/\'fego\'/s/fego/$projectname/g" index.js

# android需要更改的配置
# sed -i "" "/HotUpdatePackage;/s/HotUpdatePackage/service.HotUpdatePackage/" android/app/src/main/java/com/$projectname/MainApplication.java
# sed -i '' '29a\'$'\n''\'$'\n''@Override\'$'\n''protected String getJSMainModuleName() {\'$'\n''return "index";\'$'\n''}'$'\n' android/app/src/main/java/com/$projectname/MainApplication.java
# sed -i '' '31s/^/    /g;32s/^/    /g;33s/^/      /g;34s/^/    /g' android/app/src/main/java/com/$projectname/MainApplication.java
sed -i '' '139a\'$'\n''compile "com.squareup.retrofit2:converter-gson:2.0.0"\'$'\n' android/app/build.gradle
sed -i '' '139a\'$'\n''compile "com.squareup.retrofit2:retrofit:2.1.0"\'$'\n' android/app/build.gradle
packageName=$(echo $projectname | tr '[A-Z]' '[a-z]')
sed -i "" "s/com.packagename/com.$packageName/g" android/app/src/main/java/com/$packageName/MainActivity.java
sed -i "" "s/packagename/$projectname/g" android/app/src/main/java/com/$packageName/MainActivity.java
sed -i "" "s/com.packagename/com.$packageName/g" android/app/src/main/java/com/$packageName/MainApplication.java

