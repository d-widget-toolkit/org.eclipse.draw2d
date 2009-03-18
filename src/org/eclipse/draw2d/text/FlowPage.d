/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module org.eclipse.draw2d.text.FlowPage;

import java.lang.all;
import java.util.List;

import org.eclipse.draw2d.geometry.Dimension;
import org.eclipse.draw2d.geometry.Rectangle;
import org.eclipse.draw2d.text.BlockFlow;
import org.eclipse.draw2d.text.FlowFigureLayout;
import org.eclipse.draw2d.text.PageFlowLayout;
import org.eclipse.draw2d.text.FlowFigure;

/**
 * The root of a Flow hierarchy. A flow page can be treated as a normal figure, but
 * contains FlowFigures.
 * <P>
 * A FlowPage will not have a defined width unless it is inside a figure whose layout
 * provides width hints when calling
 * {@link org.eclipse.draw2d.IFigure#getPreferredSize(int, int)}.
 *
 * <P>WARNING: This class is not intended to be subclassed by clients.
 */
public class FlowPage
    : BlockFlow
{
    alias BlockFlow.add add;

private Dimension pageSize;
private int recommendedWidth;
private int[] pageSizeCacheKeys;
private Dimension[] pageSizeCacheValues;

public this(){
    pageSize = new Dimension();
    pageSizeCacheKeys = new int[3];
    pageSizeCacheValues = new Dimension[3];
}
/**
 * @see org.eclipse.draw2d.Figure#addNotify()
 */
public void addNotify() {
    super.addNotify();
    setValid(false);
}

/**
 * @see org.eclipse.draw2d.text.BlockFlow#createDefaultFlowLayout()
 */
protected FlowFigureLayout createDefaultFlowLayout() {
    return new PageFlowLayout(this);
}

/**
 * @see org.eclipse.draw2d.Figure#getMinimumSize(int, int)
 */
public Dimension getMinimumSize(int w, int h) {
    return getPreferredSize(w, h);
}

/**
 * @see org.eclipse.draw2d.Figure#invalidate()
 */
public void invalidate() {
    pageSizeCacheValues = new Dimension[3];
    super.invalidate();
}

/**
 * @see org.eclipse.draw2d.Figure#getPreferredSize(int, int)
 */
public Dimension getPreferredSize(int width, int h) {
    for (int i = 0; i < 3; i++) {
        if (pageSizeCacheKeys[i] is width && pageSizeCacheValues[i] !is null)
            return pageSizeCacheValues[i];
    }

    pageSizeCacheKeys[2] = pageSizeCacheKeys[1];
    pageSizeCacheKeys[1] = pageSizeCacheKeys[0];
    pageSizeCacheKeys[0] = width;

    pageSizeCacheValues[2] = pageSizeCacheValues[1];
    pageSizeCacheValues[1] = pageSizeCacheValues[0];

    //Flowpage must temporarily layout to determine its preferred size
    int oldWidth = getPageWidth();
    setPageWidth(width);
    validate();
    pageSizeCacheValues[0] = pageSize.getCopy();

    if (width !is oldWidth) {
        setPageWidth(oldWidth);
        getUpdateManager().addInvalidFigure(this);
    }
    return pageSizeCacheValues[0];
}

int getPageWidth() {
    return recommendedWidth;
}

/**
 * @see BlockFlow#postValidate()
 */
public void postValidate() {
    Rectangle r = getBlockBox().toRectangle();
    pageSize.width = r.width;
    pageSize.height = r.height;
    List v = getChildren();
    for (int i = 0; i < v.size(); i++)
        (cast(FlowFigure)v.get(i)).postValidate();
}

/**
 * Overridden to set valid.
 * @see org.eclipse.draw2d.IFigure#removeNotify()
 */
public void removeNotify() {
    super.removeNotify();
    setValid(true);
}

/**
 * @see FlowFigure#setBounds(Rectangle)
 */
public void setBounds(Rectangle r) {
    if (getBounds().opEquals(r))
        return;
    bool invalidate = getBounds().width !is r.width || getBounds().height !is r.height;
    super.setBounds(r);
    int newWidth = r.width;
    if (invalidate || getPageWidth() !is newWidth) {
        setPageWidth(newWidth);
        getUpdateManager().addInvalidFigure(this);
    }
}

private void setPageWidth(int width) {
    if (recommendedWidth is width)
        return;
    recommendedWidth = width;
    super.invalidate();
}

/**
 * @see org.eclipse.draw2d.Figure#validate()
 */
public void validate() {
    if (isValid())
        return;
    super.validate();
    postValidate();
}

}
