//
//  FeatureGraph.m
//  FeatureGraph
//
//  Created by Peter Snyder on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeatureGraph.h"
#import "FeatureGraphEdge.h"
#import "FeatureGraphNode.h"
#import "FeatureGraphRoute.h"

@implementation FeatureGraph

@synthesize nodes;

- (id)init
{
    self = [super init];

    if (self) {

        nodeEdges = [[NSMutableDictionary alloc] init];
        nodes = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (FeatureGraphNode *)nodeInGraphWithIdentifier:(NSString *)anIdentifier
{
    return [nodes objectForKey:anIdentifier];
}

- (FeatureGraphEdge *)edgeFromNode:(FeatureGraphNode *)sourceNode toNeighboringNode:(FeatureGraphNode *)destinationNode
{
    // First check to make sure a node with the identifier of the given source node exists in the graph
    if ( ! [nodeEdges objectForKey:sourceNode.identifier]) {

        return nil;
        
    } else {
        
        // Next, make sure that there is an edge from the from the given node to the destination node.  If
        // so, return it.  Otherwise, fall back on the returned nil
        return [[nodeEdges objectForKey:sourceNode.identifier] objectForKey:destinationNode.identifier];
    }
}

- (NSNumber *)weightFromNode:(FeatureGraphNode *)sourceNode toNeighboringNode:(FeatureGraphNode *)destinationNode
{
    FeatureGraphEdge *graphEdge = [self edgeFromNode:sourceNode toNeighboringNode:destinationNode];

    return (graphEdge) ? graphEdge.weight : nil;
}

- (NSInteger)edgeCount
{
    NSInteger edgeCount = 0;
    
    for (NSString *nodeIdentifier in nodeEdges) {
        
        edgeCount += [(NSDictionary *)[nodeEdges objectForKey:nodeIdentifier] count];        
    }
    
    return edgeCount;
}

- (NSSet *)neighborsOfNode:(FeatureGraphNode *)aNode
{
    NSDictionary *edgesFromNode = [nodeEdges objectForKey:aNode.identifier];
    
    // If we don't have any record of the given node in the collection, determined by its identifier,
    // return nil
    if (edgesFromNode == nil) {
        
        return nil;
        
    } else {
        
        NSMutableSet *neighboringNodes = [NSMutableSet set];

        // Otherwise, iterate over all the keys (identifiers) of nodes receiving edges
        // from the given node, retreive their coresponding node object, add it to the
        // set, and return the completed set
        for (NSString *neighboringNodeIdentifier in edgesFromNode) {
            
            [neighboringNodes addObject:[nodes objectForKey:neighboringNodeIdentifier]];
        }
        
        return neighboringNodes;
    }
}

- (NSSet *)neighborsOfNodeWithIdentifier:(NSString *)aNodeIdentifier
{    
    FeatureGraphNode *identifiedNode = [nodes objectForKey:aNodeIdentifier];
    
    return (identifiedNode == nil) ? nil : [self neighborsOfNode:identifiedNode];    
}


- (void)addEdge:(FeatureGraphEdge *)anEdge fromNode:(FeatureGraphNode *)aNode toNode:(FeatureGraphNode *)anotherNode
{
    [nodes setObject:aNode forKey:aNode.identifier];
    [nodes setObject:anotherNode forKey:anotherNode.identifier];

    // If we don't have any edges leaving from from the given node (aNode),
    // create a new record in the node dictionary.  Otherwise just add the new edge / connection to the
    // collection
    if ([nodeEdges objectForKey:aNode.identifier] == nil) {

        [nodeEdges setObject:[NSMutableDictionary dictionaryWithObject:anEdge
                                                                forKey:anotherNode.identifier]
                      forKey:aNode.identifier];

    } else {
        
        [(NSMutableDictionary *)[nodeEdges objectForKey:aNode.identifier] setObject:anEdge
                                                                             forKey:anotherNode.identifier];

    }
}

- (BOOL)removeEdgeFromNode:(FeatureGraphNode*)aNode toNode:(FeatureGraphNode*)anotherNode 
{  
    // Check to see if the edge exists.  No such edge exists, return false and do nothing
    if ([[nodeEdges objectForKey:aNode.identifier] objectForKey:anotherNode.identifier] == nil) {

        return NO;
    
    } else {
             
        // Otherwise, remove the relevant edge and return YES
        [[nodeEdges objectForKey:aNode.identifier] removeObjectForKey:anotherNode.identifier];
        return YES;
    }    
}

- (void)addBiDirectionalEdge:(FeatureGraphEdge *)anEdge fromNode:(FeatureGraphNode *)aNode toNode:(FeatureGraphNode *)anotherNode
{    
    [self addEdge:anEdge fromNode:aNode toNode:anotherNode];
    [self addEdge:anEdge fromNode:anotherNode toNode:aNode];    
}

- (BOOL)removeBiDirectionalEdgeFromNode:(FeatureGraphNode*)aNode toNode:(FeatureGraphNode*)anotherNode 
{
    // First, make sure edges exist in both directions.  If they don't, return NO and do nothing
    FeatureGraphEdge *toEdge = [self edgeFromNode:aNode toNeighboringNode:anotherNode];
    FeatureGraphEdge *fromEdge = [self edgeFromNode:anotherNode toNeighboringNode:aNode];
    
    if (toEdge == nil || fromEdge == nil) {
        
        return NO;
        
    } else {
        
        [self removeEdgeFromNode:aNode toNode:anotherNode];
        [self removeEdgeFromNode:anotherNode toNode:aNode];
        return YES;

    }
}

//rewritten impl
////url http://www.vogella.com/articles/JavaAlgorithmsDijkstra/article.html
//- (NSArray *)shortestRouteFromNode:(FeatureGraphNode *)startNode {
//    NSLog(@"FeatureGraph.shortestRotueFromNode() new");
//	//java execute(Vertex source)
//	/*
//     settledNodes = new HashSet<Vertex>();
//     unSettledNodes = new HashSet<Vertex>();
//     distance = new HashMap<Vertex, Integer>();
//     predecessors = new HashMap<Vertex, Vertex>();
//     distance.put(source, 0);
//     unSettledNodes.add(source);
//     while (unSettledNodes.size() > 0) {
//     Vertex node = getMinimum(unSettledNodes);
//     settledNodes.add(node);
//     unSettledNodes.remove(node);
//     findMinimalDistances(node);
//     }*/
//	NSMutableDictionary *settledNodes = [NSMutableDictionary dictionaryWithCapacity:[self.nodes count]];
//	NSMutableDictionary *unsettledNodes = [NSMutableDictionary dictionaryWithCapacity:[self.nodes count]];
//	NSMutableDictionary *distance = [NSMutableDictionary dictionaryWithCapacity:[self.nodes count]];
//	NSMutableDictionary *predecessors = [NSMutableDictionary dictionaryWithCapacity:[self.nodes count]];
//	[distance setValue:[NSNumber numberWithInt:0] forKey:startNode.identifier];
//	[unsettledNodes setValue:startNode forKey:startNode.identifier];
//	NSNumber *maxValue = [NSNumber numberWithDouble:DBL_MAX]; //may have to import float.h
//	FeatureGraphNode *lastNode;
//	
//	while ([unsettledNodes count] > 0) {
//        NSLog(@"in top loop");
//		NSString *identifierOfSmallestDist = [self keyOfSmallestValue:distance withInKeys:[unsettledNodes allKeys]];
//		FeatureGraphNode *node = [self.nodes objectForKey:identifierOfSmallestDist];
//		[settledNodes setValue:node forKey:identifierOfSmallestDist];
//		[unsettledNodes removeObjectForKey:identifierOfSmallestDist];
//		
//		//java findMinimalDistances(Vertex node)
//		/*
//         List<Vertex> adjacentNodes = getNeighbors(node);
//         for (Vertex target : adjacentNodes) {
//         if (getShortestDistance(target) > getShortestDistance(node)
//         + getDistance(node, target)) {
//         distance.put(target, getShortestDistance(node) + getDistance(node, target));
//         predecessors.put(target, node);
//         unSettledNodes.add(target);
//         }
//         }
//         */
//		NSSet *adjacentNodes = [self neighborsOfNodeWithIdentifier:identifierOfSmallestDist];
//        for (FeatureGraphNode* targetNode in adjacentNodes) {
//			//getShortestDistance(Vertex destination)
//			/*
//             Integer d = distance.get(destination);
//             if (d == null) {
//             return Integer.MAX_VALUE;
//             } else {
//             return d;
//             }
//             */
//			NSNumber *distanceTarget = [distance objectForKey:targetNode.identifier];
//			if(distanceTarget == nil) {
//				distanceTarget = maxValue;
//			}
//			NSNumber *distanceNode = [distance objectForKey:node.identifier];
//			if(distanceNode == nil) {
//				distanceNode = maxValue;
//			}
//			NSNumber *distanceFromNodeToTarget = [self weightFromNode:node toNeighboringNode:targetNode];
//			NSNumber *distanceFromNodeToTargetThroughSource = [NSNumber numberWithDouble:(distanceNode.doubleValue + distanceFromNodeToTarget.doubleValue)];
//			
//			if(distanceTarget.doubleValue > distanceFromNodeToTargetThroughSource.doubleValue) {
//				[distance setValue:[NSNumber numberWithInt:distanceFromNodeToTargetThroughSource] forKey:targetNode.identifier];
//				[predecessors setValue:targetNode forKey:node.identifier];
//				[unsettledNodes setValue:targetNode forKey:targetNode.identifier];
//                NSLog(@"added targetNode:%@ forKey:%@", targetNode.identifier, node.identifier);
//				lastNode = targetNode;
//			}
//		}
//		
//	}
//    NSLog(@"out of loops");
//	
//	//getPath(Vertex Target) //target is lastNode
//	/*
//     LinkedList<Vertex> path = new LinkedList<Vertex>();
//     Vertex step = target;
//     // Check if a path exists
//     if (predecessors.get(step) == null) {
//     return null;
//     }
//     path.add(step);
//     while (predecessors.get(step) != null) {
//     step = predecessors.get(step);
//     path.add(step);
//     }
//     // Put it into the correct order
//     Collections.reverse(path);
//     return path;
//     */
//    NSLog(@"predecessors.count = %u", predecessors.count);
//	NSMutableArray *reverseRoute = [[NSMutableArray alloc] initWithCapacity:predecessors.count];
//	FeatureGraphNode *step = lastNode;
//    NSLog(@"lastNode.identifier = %@", lastNode.identifier);
//    NSLog(@"object for lastNoe.identifier = %@", [predecessors objectForKey:step.identifier]);
//	if([predecessors objectForKey:step.identifier] == nil) {
//		NSLog(@"Error lastNode next object is nil");
//		return nil;
//	}
//	[reverseRoute addObject:step];
//	//[predecessors removeObjectForKey:step.identifier];
//    
//	while([predecessors objectForKey:step.identifier] != nil) {
//        NSLog(@"in reverse loop: prev identifier: %@", step.identifier);
//		step = [predecessors objectForKey:step.identifier]; //nextStep
//        NSLog(@"in reverse loop: next identifier: %@", step.identifier);
//		[reverseRoute addObject:step];
//        [predecessors removeObjectForKey:step.identifier];
//	}
//	
//    //just reverse the route
//	NSMutableArray *route = [[NSMutableArray alloc] initWithCapacity:reverseRoute.count];
//	for(int i=reverseRoute.count; i>0; i--) {
//		FeatureGraphNode *nextStep = reverseRoute[i];
//		[route addObject:nextStep];
//        NSLog(@"added to route: %@", nextStep.identifier);
//	}
//	
//    NSLog(@"new route.count = %u", route.count);
//	return route;
//}



//- (NSArray *)shortestRouteFromNode:(FeatureGraphNode *)startNode {
//    /*
//     for each vertex v in Graph:                                // Initializations
//     3          dist[v] := infinity ;                                  // Unknown distance function from
//     4                                                                 // source to v
//     5          previous[v] := undefined ;                             // Previous node in optimal path
//     6      end for                                                    // from source
//     7
//     */
//    //set all distances to infinity
//    // Since NSNumber doesn't have a state for infinitiy, but since we know that all weights have to be positive, we can treat -1 as infinity
//    NSNumber *infinity = [NSNumber numberWithInt:-1];
//    NSMutableDictionary *distancesFromSource = [NSMutableDictionary dictionaryWithCapacity:self.nodes.count];
//    NSMutableDictionary *previousNodeInOptimalPath = [NSMutableDictionary dictionaryWithCapacity:self.nodes.count];
//    for (NSString *nodeIdentifier in nodes) {
//        [distancesFromSource setValue:infinity forKey:nodeIdentifier];
//    }
//    
//    /*
//     8      dist[source] := 0 ;                                        // Distance from source to source
//     9      Q := the set of all nodes in Graph ;                       // All nodes in the graph are
//     10                                                                 // unoptimized - thus are in Q
//     */
//    [distancesFromSource setValue:[NSNumber numberWithInt:0]
//                                forKey:startNode.identifier];
//    NSMutableDictionary *unexaminedNodes = [NSMutableDictionary dictionaryWithDictionary:self.nodes];
//    /*
//     11      while Q is not empty:                                      // The main loop
//     12          u := vertex in Q with smallest distance in dist[] ;    // Start node in first case
//     13          remove u from Q ;
//     */
//    while ([unexaminedNodes count] > 0) {
//        NSString *identifierOfSmallestDist = [self keyOfSmallestValue:distancesFromSource withInKeys:[unexaminedNodes allKeys]];
//        [unexaminedNodes removeObjectForKey:identifierOfSmallestDist];
//    /*
//     14          if dist[u] = infinity:
//     15              break ;                                            // all remaining vertices are
//     16          end if                                                 // inaccessible from source
//     17
//     18          for each neighbor v of u:                              // where v has not yet been
//     19                                                                 // removed from Q.
//     20              alt := dist[u] + dist_between(u, v) ;
//     21              if alt < dist[v]:                                  // Relax (u,v,a)
//     22                  dist[v] := alt ;
//     23                  previous[v] := u ;
//     24                  decrease-key v in Q;                           // Reorder v in the Queue
//     25              end if
//     26          end for
//     */
//    }
//     /*
//     27      end while
//     /*
//}



//that dikstra algo wasn't giving wanted results (eliminated stops??), i think
//its because the neighbors aren't setup right, the algo is expecting not every node
//to be a neighbor, when every node is a neighbor it doesn't work, so
//just use this.. its just a prototype. it isn't exactly right, but am out of time
//to get it right. may be close enough for right now
- (NSArray *)shortestRouteFromNode:(FeatureGraphNode *)startNode
{
    NSMutableArray *route = [NSMutableArray arrayWithCapacity:nodes.count];
    NSMutableDictionary *unexaminedNodes = [NSMutableDictionary dictionaryWithDictionary:self.nodes];
    
    FeatureGraphNode *lastNode = startNode;
    [route addObject:lastNode]; //add start node
    [unexaminedNodes removeObjectForKey:lastNode.identifier];
    int i=1;//already added startNode, so start at 1
    while(i<nodes.count) {
        //get distance to closest node
        double distance = -1;
        NSArray *keys = [unexaminedNodes allKeys];
        FeatureGraphNode *tempNode;
        for(int j=0; j<keys.count; j++) {
            NSString *key = keys[j];
            FeatureGraphNode *nextNode = [nodes objectForKey:key];
            if(![lastNode.identifier isEqualToString:nextNode.identifier]) { //don't want to compare this node
                FeatureGraphEdge *edge = [self edgeFromNode:lastNode toNeighboringNode:nextNode];
                
                if(distance==-1 || edge.weight.doubleValue < distance) {
                    distance = edge.weight.doubleValue;
                    tempNode = nextNode;
                }
            }
        }
        [route addObject:tempNode];
        [unexaminedNodes removeObjectForKey:lastNode.identifier];
        lastNode = tempNode;
        
        i++;
    }
    
    for(int i=0; i<route.count; i++) {
        FeatureGraphNode *step = route[i];
        NSLog(@"step = %@", step.identifier);
    }
    
    return route;
}


// Returns the quickest possible path between two nodes, using Dijkstra's algorithm
// http://en.wikipedia.org/wiki/Dijkstra's_algorithm
- (FeatureGraphRoute *)shortestRouteFromNode:(FeatureGraphNode *)startNode toNode:(FeatureGraphNode *)endNode
{
    NSMutableDictionary *unexaminedNodes = [NSMutableDictionary dictionaryWithDictionary:self.nodes];

    // The shortest yet found distance to the origin for each node in the graph.  If we haven't
    // yet found a path back to the origin from a node, or if there isn't one, mark with -1 
    // (which is used equivlently to how infinity is used in some Dijkstra implementations)
    NSMutableDictionary *distancesFromSource = [NSMutableDictionary dictionaryWithCapacity:[unexaminedNodes count]];
    
    // A collection that stores the previous node in the quickest path back to the origin for each
    // examined node in the graph (so you can retrace the fastest path from any examined node back
    // looking up the value that coresponds to any node identifier.  That value will be the previous
    // node in the path
    NSMutableDictionary *previousNodeInOptimalPath = [NSMutableDictionary dictionaryWithCapacity:[unexaminedNodes count]];

    // Since NSNumber doesn't have a state for infinitiy, but since we know that all weights have to be
    // positive, we can treat -1 as infinity
    NSNumber *infinity = [NSNumber numberWithInt:-1];

    // Set every node to be infinitely far from the origin (ie no path back has been found yet).
    for (NSString *nodeIdentifier in unexaminedNodes) {
        
        [distancesFromSource setValue:infinity
                               forKey:nodeIdentifier];
    }

    // Set the distance from the source to itself to be zero
    [distancesFromSource setValue:[NSNumber numberWithInt:0]
                           forKey:startNode.identifier];

    NSString *currentlyExaminedIdentifier = nil;

    while ([unexaminedNodes count] > 0) {

        // Find the node, of all the unexamined nodes, that we know has the closest path back to the origin
        NSString *identifierOfSmallestDist = [self keyOfSmallestValue:distancesFromSource withInKeys:[unexaminedNodes allKeys]];

        // If we failed to find any remaining nodes in the graph that are reachable from the source,
        // stop processing
        if (identifierOfSmallestDist == nil) {

            break;            
        
        } else {

            FeatureGraphNode *nodeMostRecentlyExamined = [self nodeInGraphWithIdentifier:identifierOfSmallestDist];
            
            // If the next closest node to the origin is the target node, we don't need to consider any more
            // possibilities, we've already hit the shortest distance!  So, we can remove all other 
            // options from consideration.
            if ([identifierOfSmallestDist isEqualToString:endNode.identifier]) {

                currentlyExaminedIdentifier = endNode.identifier;
                break;

            } else {

                // Otherwise, remove the node thats the closest to the source and continue the search by looking
                // for the next closest item to the orgin. 
                [unexaminedNodes removeObjectForKey:identifierOfSmallestDist];
                
                // Now, iterate over all the nodes that touch the one closest to the graph
                for (FeatureGraphNode *neighboringNode in [self neighborsOfNodeWithIdentifier:identifierOfSmallestDist]) {
                    
                    // Calculate the distance to the origin, from the neighboring node, through the most recently
                    // examined node.  If its less than the shortest path we've found from the neighboring node
                    // to the origin so far, save / store the new shortest path amount for the node, and set
                    // the currently being examined node to be the optimal path home
                    // The distance of going from the neighbor node to the origin, going through the node we're about to eliminate
                    NSNumber *alt = [NSNumber numberWithFloat:
                                     [[distancesFromSource objectForKey:identifierOfSmallestDist] floatValue] +
                                     [[self weightFromNode:nodeMostRecentlyExamined toNeighboringNode:neighboringNode] floatValue]];
                    
                    NSNumber *distanceFromNeighborToOrigin = [distancesFromSource objectForKey:neighboringNode.identifier];

                    // If its quicker to get to the neighboring node going through the node we're about the remove 
                    // than through any other path, record that the node we're about to remove is the current fastes
                    if ([distanceFromNeighborToOrigin isEqualToNumber:infinity] || [alt compare:distanceFromNeighborToOrigin] == NSOrderedAscending) {

                        [distancesFromSource setValue:alt forKey:neighboringNode.identifier];
                        [previousNodeInOptimalPath setValue:nodeMostRecentlyExamined forKey:neighboringNode.identifier];
                    }
                }                
            }
        }
    }

    // There are two situations that cause the above loop to exit,
    // 1. We've found a path between the origin and the destination node, or
    // 2. there are no more possible routes to consider to the destination, in which case no possible
    // solution / route exists.
    //
    // If the key of the destination node is equal to the node we most recently found to be in the shortest path 
    // between the origin and the destination, we're in situation 2.  Otherwise, we're in situation 1 and we
    // should just return nil and be done with it
    if ( currentlyExaminedIdentifier == nil || ! [currentlyExaminedIdentifier isEqualToString:endNode.identifier]) {
        
        return nil;
        
    } else {
        
        // If we did successfully find a path, create and populate a route object, describing each step
        // of the path.
        FeatureGraphRoute *route = [[FeatureGraphRoute alloc] init];
        
        // We do this by first building the route backwards, so the below array with have the last step
        // in the route (the destination) in the 0th position, and the origin in the last position
        NSMutableArray *nodesInRouteInReverseOrder = [NSMutableArray array];

        [nodesInRouteInReverseOrder addObject:endNode];
        
        FeatureGraphNode *lastStepNode = endNode;
        FeatureGraphNode *previousNode;
        
        while ((previousNode = [previousNodeInOptimalPath objectForKey:lastStepNode.identifier])) {
            
            [nodesInRouteInReverseOrder addObject:previousNode];
            lastStepNode = previousNode;
        }

        // Now, finally, at this point, we can reverse the array and build the complete route object, by stepping through 
        // the nodes and piecing them togheter with their routes
        NSUInteger numNodesInPath = [nodesInRouteInReverseOrder count];
        for (int i = numNodesInPath - 1; i >= 0; i--) {
            
            FeatureGraphNode *currentGraphNode = [nodesInRouteInReverseOrder objectAtIndex:i];
            FeatureGraphNode *nextGraphNode = (i - 1 < 0) ? nil : [nodesInRouteInReverseOrder objectAtIndex:(i - 1)];
            
            [route addStepFromNode:currentGraphNode withEdge:nextGraphNode ? [self edgeFromNode:currentGraphNode toNeighboringNode:nextGraphNode] : nil];
        }
        
        return route;
    }
}

- (id)keyOfSmallestValue:(NSDictionary *)aDictionary withInKeys:(NSArray *)anArray
{
    id keyForSmallestValue = nil;
    NSNumber *smallestValue = nil;
    
    NSNumber *infinity = [NSNumber numberWithInt:-1];
    
    for (id key in anArray) {

        // Check to see if we have or proxie for infinity here.  If so, ignore this value
        NSNumber *currentTestValue = [aDictionary objectForKey:key];

       //cbm removed this.. they're all starting at infinity, so this causes nothing to happen
        if ( ! [currentTestValue isEqualToNumber:infinity]) {
                        
            if (smallestValue == nil || [smallestValue compare:currentTestValue] == NSOrderedDescending) {

                keyForSmallestValue = key;
                smallestValue = currentTestValue;
            }
        }
    }
    
    NSLog(@"keyForSmallestValue = %@", keyForSmallestValue);
    
    return keyForSmallestValue;
}

@end
