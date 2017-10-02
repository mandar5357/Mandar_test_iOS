
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

/**
 *  Convenience block definition for setting formatter defaults.  
 *
 *  @discussion Sets any defaults needed on the NSFormatter. This is run before all invocations of the formatter
 *
 *  @param formatter A NSFormatter subclass.
 */
typedef void (^VVFormatterDefaultsBlock)(id formatter);

/**
 *  Convenience block definition for executing formatter commands.  
 *
 *  @discussion The formatter block contains all commands that should be run on the cached formatter instance to return a value.
 *
 *  @param formatter A NSFormatter subclass.
 *
 *  @return The return value from the NSFormatter.
 */
typedef id (^VVFormatterBlock)(id formatter);

/**
 *  This class wraps a NSFormatter subclass with a gcd serial queue to ensure only one operation runs on the formatter at any given time.
 */
@interface MMFormatter : NSObject


/**
 *  Init with a NSFormatter subclass.
 *
 *  @param formatterInstance NSFormatter subclass instance.
 *
 *  @return An instance of VVFormatter.
 */
- (instancetype)initWithFormatter:(id)formatterInstance;

/**
 *  This method runs the actual formatting sequence on the NSFormatter sublcass
 *
 *  @discussion formatWithDefaults is the heart of the library. It queues formatter blocks on a serial gcd queue to ensure seperation between accesses to the shared formatters.
 *
 *  @param defaults    Formatter defaults block.
 *  @param formatBlock Formatter formatting block.
 *
 *  @return Returns anything a NSFormatter can return hence the return type is id.
 */
- (id)formatWithDefaults:(VVFormatterDefaultsBlock)defaults format:(VVFormatterBlock)formatBlock;

@end
