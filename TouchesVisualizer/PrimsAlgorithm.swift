//
//  PrimsAlgorithm.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import Foundation

protocol Distancable {
    associatedtype Distance: Comparable
    static func distance(from: Self, to: Self) -> Distance
}

struct PrimsAlgorithm<Node: Distancable & Equatable & Hashable> {

    struct Arc: Hashable {
        let node1: Node
        let node2: Node
    }

    private typealias DistanceCache = [Arc: Node.Distance]
    private let nodes: [Node]

    init(nodes: [Node]) {
        self.nodes = nodes
    }

    func execute() -> [Arc] {
        guard !nodes.isEmpty else { return [] }

        var arcs: [Arc] = []

        var usedNodes = [nodes.first!]
        var remainingNodes = Array(nodes.dropFirst())

        var distanceCache: [Arc: Node.Distance] = [:]

        while !remainingNodes.isEmpty {
            let (closestNode, arc) = closestNode(from: remainingNodes, to: usedNodes, distanceCache: &distanceCache)
            let closestIndex = remainingNodes.firstIndex { $0 == closestNode }!
            remainingNodes.remove(at: closestIndex)
            usedNodes.append(closestNode)
            arcs.append(arc)
        }

        return arcs
    }

    // MARK: - Private

    private func closestNode(from targetNodes: [Node], to groupedNodes: [Node], distanceCache: inout DistanceCache) -> (Node, Arc) {
        assert(!targetNodes.isEmpty)
        assert(!groupedNodes.isEmpty)

        let (node, closestNode, _) = groupedNodes
            .map { node -> (Node, Node, Node.Distance) in
                let (distance, closestNode) = self.closestNode(from: node, to: targetNodes, distanceCache: &distanceCache)
                return (node, closestNode, distance)
            }
            .min { $0.2 < $1.2 }!
        return (closestNode, Arc(node1: node, node2: closestNode))

    }

    private func closestNode(from node: Node, to nodes: [Node], distanceCache: inout DistanceCache) -> (Node.Distance, Node) {
        assert(!nodes.isEmpty)
        return nodes
            .map { (distance(from: $0, to: node, distanceCache: &distanceCache), $0) }
            .min { $0.0 < $1.0 }!
    }

    private func distance(from node1: Node, to node2: Node, distanceCache: inout DistanceCache) -> Node.Distance {
        let arc = Arc(node1: node1, node2: node2)
        if let distance = distanceCache[arc] {
            return distance
        }
        let distance = Node.distance(from: node1, to: node2)
        distanceCache[arc] = distance
        return distance
    }
}
