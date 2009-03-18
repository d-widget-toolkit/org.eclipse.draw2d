/*******************************************************************************
 * Copyright (c) 2003, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module org.eclipse.draw2d.graph.CompoundHorizontalPlacement;

import java.lang.all;
import java.util.HashSet;
import java.util.Set;
import org.eclipse.draw2d.graph.HorizontalPlacement;
import org.eclipse.draw2d.graph.Node;
import org.eclipse.draw2d.graph.RankList;
import org.eclipse.draw2d.graph.Rank;
import org.eclipse.draw2d.graph.Subgraph;
import org.eclipse.draw2d.graph.SubgraphBoundary;
import org.eclipse.draw2d.graph.DirectedGraph;
import org.eclipse.draw2d.graph.NodeList;
import org.eclipse.draw2d.graph.CompoundDirectedGraph;
import org.eclipse.draw2d.graph.Edge;
import org.eclipse.draw2d.graph.GraphUtilities;

/**
 * Calculates the X-coordinates for nodes in a compound directed graph.
 * @author Randy Hudson
 * @since 2.1.2
 */
class CompoundHorizontalPlacement : HorizontalPlacement {

class LeftRight {
    //$TODO Delete and use NodePair class, equivalent
    Object left, right;
    this(Object l, Object r) {
        left = l; right = r;
    }
    public override int opEquals(Object obj) {
        LeftRight entry = cast(LeftRight)obj;
        return entry.left.opEquals(left) && entry.right.opEquals(right);
    }
    public override hash_t toHash() {
        return left.toHash() ^ right.toHash();
    }
}

Set entries;

public this(){
    entries = new HashSet();
}

/**
 * @see org.eclipse.graph.HorizontalPlacement#applyGPrime()
 */
void applyGPrime() {
    super.applyGPrime();
    NodeList subgraphs = (cast(CompoundDirectedGraph)graph).subgraphs;
    for (int i = 0; i < subgraphs.size(); i++) {
        Subgraph s = cast(Subgraph)subgraphs.get(i);
        s.x = s.left.x;
        s.width = s.right.x + s.right.width - s.x;
    }
}

/**
 * @see HorizontalPlacement#buildRankSeparators(RankList)
 */
void buildRankSeparators(RankList ranks) {
    CompoundDirectedGraph g = cast(CompoundDirectedGraph)graph;

    Rank rank;
    for (int row = 0; row < g.ranks.size(); row++) {
        rank = g.ranks.getRank(row);
        Node n = null, prev = null;
        for (int j = 0; j < rank.size(); j++) {
            n = rank.getNode(j);
            if (prev is null) {
                Node left = addSeparatorsLeft(n, null);
                if (left !is null) {
                    Edge e = new Edge(graphLeft, getPrime(left), 0, 0);
                    prime.edges.add(e);
                    e.delta = graph.getPadding(n).left + graph.getMargin().left;
                }

            } else {
                Subgraph s = GraphUtilities.getCommonAncestor(prev, n);
                Node left = addSeparatorsRight(prev, s);
                Node right = addSeparatorsLeft(n, s);
                createEdge(left, right);
            }
            prev = n;
        }
        if (n !is null)
            addSeparatorsRight(n, null);
    }
}

void createEdge(Node left, Node right) {
    LeftRight entry = new LeftRight(left, right);
    if (entries.contains(entry))
        return;
    entries.add(entry);
    int separation = left.width
            + graph.getPadding(left).right
            + graph.getPadding(right).left;
    prime.edges.add(new Edge(
        getPrime(left), getPrime(right), separation, 0
    ));
}

Node addSeparatorsLeft(Node n, Subgraph graph) {
    Subgraph parent = n.getParent();
    while (parent !is graph && parent !is null) {
        createEdge(getLeft(parent), n);
        n = parent.left;
        parent = parent.getParent();
    }
    return n;
}

Node addSeparatorsRight(Node n, Subgraph graph) {
    Subgraph parent = n.getParent();
    while (parent !is graph && parent !is null) {
        createEdge(n, getRight(parent));
        n = parent.right;
        parent = parent.getParent();
    }
    return n;
}

Node getLeft(Subgraph s) {
    if (s.left is null) {
        s.left = new SubgraphBoundary(s, graph.getPadding(s), 1);
        s.left.rank = (s.head.rank + s.tail.rank) / 2;

        Node head = getPrime(s.head);
        Node tail = getPrime(s.tail);
        Node left = getPrime(s.left);
        Node right = getPrime(getRight(s));
        prime.edges.add(new Edge(left, right, s.width, 0));
        prime.edges.add(new Edge(left, head, 0, 1));
        prime.edges.add(new Edge(head, right, 0, 1));
        prime.edges.add(new Edge(left, tail, 0, 1));
        prime.edges.add(new Edge(tail, right, 0, 1));
    }
    return s.left;
}

Node getRight(Subgraph s) {
    if (s.right is null) {
        s.right = new SubgraphBoundary(s, graph.getPadding(s), 3);
        s.right.rank = (s.head.rank + s.tail.rank) / 2;
    }
    return s.right;
}

Node getPrime(Node n) {
    Node nPrime = get(n);
    if (nPrime is null) {
        nPrime = new Node(n);
        prime.nodes.add(nPrime);
        map(n, nPrime);
    }
    return nPrime;
}

public void visit(DirectedGraph g) {
    super.visit(g);
}

}
