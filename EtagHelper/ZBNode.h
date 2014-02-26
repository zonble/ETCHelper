#import <Foundation/Foundation.h>

/*! Data object for a node. */
@interface ZBNode : NSObject

/*! Creates a new instance by giving its name.
    @praram inName name of the node */
- (instancetype)initWithName:(NSString *)inName;

/*! Creates a link toward another node.
    @param iNode the node where we link to
    @param inPrice how much does driving on the link cost.
    @param tag actually it is the name of the freeway where the link
    belongs to.*/
- (void)makeLinkTowardNode:(ZBNode *)inNode forPrice:(double)inPrice tag:(NSString *)inTag;

/*! Returns an array of links by filtering out given destinations.
    @param inNodes the nodes that we want to use during filtering.*/
- (NSArray *)linksBesideTowardNodes:(NSSet *)inNodes;

/*! Name of the node. */
@property (readonly) NSString *name;
/*! Links of the node. */
@property (readonly) NSArray *links;
@end

/*! A convinient function for building links between nodes. */
void makeLinkBetweenNodes(ZBNode *aNode, ZBNode *bNode, double price, NSString *tag);
