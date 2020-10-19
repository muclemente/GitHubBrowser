project:
	xcodegen generate
	pod install
	/usr/libexec/PlistBuddy -c "Set :User $(user)" ./Provider/Supporting\ Files/GithubAPICredentials.plist
	/usr/libexec/PlistBuddy -c "Set :Token $(token)" ./Provider/Supporting\ Files/GithubAPICredentials.plist