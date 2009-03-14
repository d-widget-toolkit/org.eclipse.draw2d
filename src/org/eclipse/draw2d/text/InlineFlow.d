/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module org.eclipse.draw2d.text.InlineFlow;

import java.lang.all;

import org.eclipse.swt.SWT;
import org.eclipse.draw2d.Border;
import org.eclipse.draw2d.ColorConstants;
import org.eclipse.draw2d.Graphics;
import org.eclipse.draw2d.geometry.Rectangle;
import org.eclipse.draw2d.text.FlowFigure;
import org.eclipse.draw2d.text.FlowFigureLayout;
import org.eclipse.draw2d.text.FlowBox;
import org.eclipse.draw2d.text.InlineFlowLayout;
import org.eclipse.draw2d.text.FlowBorder;

/**
 * A <code>FlowFigure</code> represented by multiple <code>LineBox</code> fragments. An
 * <code>InlineFlow</code>'s parent must be either a {@link BlockFlow} or another
 * InlineFlow.
 *
 * <P>An InlineFlow may contain other InlineFlow figures.
 *
 * <P>WARNING: This class is not intended to be subclassed by clients.
 * @author Randy Hudson
 * @since 2.0
 */
public class InlineFlow : FlowFigure {

List fragments;

public this(){
    fragments = new ArrayList(1);
}

/**
 * Iterates over the children to find the width before a line-break is encountered.
 * @see org.eclipse.draw2d.text.FlowFigure#addLeadingWordRequirements(int[])
 */
public bool addLeadingWordRequirements(int[] width) {
    Iterator iter = getChildren().iterator();
    while (iter.hasNext()) {
        if ((cast(FlowFigure)iter.next()).addLeadingWordRequirements(width))
            return true;
    }
    return false;
}

/**
 * Extended to return false if the point is not also contained by at least one fragment.
 * @return <code>true</code> if a fragment contains the given point
 * @param x the relative x coordinate
 * @param y the relative y coordinate
 */
public bool containsPoint(int x, int y) {
    if (super.containsPoint(x, y)) {
        List frags = getFragments();
        for (int i = 0; i < frags.size(); i++)
            if ((cast(FlowBox)frags.get(i)).containsPoint(x, y))
                return true;
    }

    return false;
}

/**
 * @see FlowFigure#createDefaultFlowLayout()
 */
protected FlowFigureLayout createDefaultFlowLayout() {
    return new InlineFlowLayout(this);
}

/**
 * Returns the <code>FlowBox</code> fragments contained in this InlineFlow.  The returned
 * list should not be modified.
 * @return The fragments
 */
public List getFragments() {
    return fragments;
}

/**
 * Overridden to paint a {@link FlowBorder} if present, and draw selection. The border is
 * painted first, followed by selection which is generally done in XOR, which still allows
 * the border to be seen.
 * @param graphics the graphics
 */
protected void paintBorder(Graphics graphics) {
    if (getBorder() !is null) {
        FlowBorder fb = cast(FlowBorder)getBorder();
        List frags = getFragments();
        Rectangle where = new Rectangle();
        int sides;
        for (int i = 0; i < frags.size(); i++) {
            FlowBox box = cast(FlowBox)frags.get(i);

            where.x = box.getX();
            where.width = box.getWidth();
            where.y = -box.getAscentWithBorder();
            where.height = box.getDescentWithBorder() - where.y;
            where.y += box.getBaseline();
            sides = 0;
            if (i is 0)
                sides = SWT.LEAD;
            if (i is frags.size() - 1)
                sides |= SWT.TRAIL;
            fb.paint(this, graphics, where, sides);
        }
        graphics.restoreState();
    }
    if (selectionStart !is -1)
        paintSelection(graphics);
}

/**
 * Renders the XOR selection rectangles to the graphics.
 * @param graphics the graphics to paint on
 * @since 3.1
 */
protected void paintSelection(Graphics graphics) {
    graphics.restoreState();
    graphics.setXORMode(true);
    graphics.setBackgroundColor(ColorConstants.white);
    List list = getFragments();
    FlowBox box;
    for (int i = 0; i < list.size(); i++) {
        box = cast(FlowBox)list.get(i);
        int top = box.getLineRoot().getVisibleTop();
        int bottom = box.getLineRoot().getVisibleBottom();
        graphics.fillRectangle(box.getX(), top, box.getWidth(), bottom - top);
    }
}

/**
 * @see FlowFigure#postValidate()
 */
public void postValidate() {
    List list = getFragments();
    FlowBox box;
    int left = Integer.MAX_VALUE, top = left;
    int right = Integer.MIN_VALUE, bottom = right;

    for (int i = 0; i < list.size(); i++) {
        box = cast(FlowBox)list.get(i);
        left = Math.min(left, box.getX());
        right = Math.max(right, box.getX() + box.getWidth());
        top = Math.min(top, box.getLineRoot().getVisibleTop());
        bottom = Math.max(bottom, box.getLineRoot().getVisibleBottom());
    }

    setBounds(new Rectangle(left, top, right - left, bottom - top));
    repaint();
    list = getChildren();
    for (int i = 0; i < list.size(); i++)
        (cast(FlowFigure)list.get(i)).postValidate();
}

/**
 * Overridden to assert that only {@link FlowBorder} is used. <code>null</code> is still a
 * valid value as well.
 * @param  border <code>null</code> or a FlowBorder
 */
public void setBorder(Border border) {
    if (border is null || null !is cast(FlowBorder)border )
        super.setBorder(border);
    else
        throw new RuntimeException("Border must be an instance of FlowBorder"); //$NON-NLS-1$
}

}