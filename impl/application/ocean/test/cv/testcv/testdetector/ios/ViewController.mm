/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ViewController.h"

#include "ocean/base/Messenger.h"
#include "ocean/base/StringApple.h"

#include "ocean/platform/apple/Resource.h"

#include "ocean/test/testcv/testdetector/TestCVDetector.h"

using namespace Ocean;

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	// writing the logs to standard output (e.g,. debug window) and queuing the messages to allow popping them
	Messenger::get().setOutputType(Messenger::MessageOutput(Messenger::OUTPUT_STANDARD | Messenger::OUTPUT_QUEUED));


	// define the number of seconds each test is applied
	const double testDurations = 2.0;

	// define the subset of functions which will be invoked, an empty set invokes all functions
	const std::string testFunctions;

	// we seek for the resource file containing the media file
	const std::wstring testMediaFilename = Platform::Apple::Resource::resourcePath(L"tropical-island-with-toucans_800x800", L"jpg");

	Test::TestCV::TestDetector::testCVDetectorAsynchron(testDurations, String::toAString(testMediaFilename), testFunctions);

	[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
}

- (void)timerTicked:(NSTimer*)timer
{
	const std::string message(Messenger::get().popMessage());

	if (!message.empty())
	{
		[_controllerTextView setText:[[_controllerTextView text] stringByAppendingString:StringApple::toNSString(message + std::string("\n"))]];
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

@end
