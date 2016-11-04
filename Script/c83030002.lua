--Carefree Mary
function c83030002.initial_effect(c)
	c:SetUniqueOnField(1,0,83030002)
	--Xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x833),3,2)
	c:EnableReviveLimit()
	--Attach material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83030002,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,83030002)
	e1:SetTarget(c83030002.attg)
	e1:SetOperation(c83030002.atop)
	c:RegisterEffect(e1)
	--Change battle position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83030002,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,8303002)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c83030002.cost)
	e2:SetTarget(c83030002.tg)
	e2:SetOperation(c83030002.op)
	c:RegisterEffect(e2)
end
function c83030002.filter(c,tp)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler() and c:IsSetCard(0x833) and c:IsFaceup() 
		and c:GetOwner()==tp
end
function c83030002.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x833)
end
function c83030002.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c83030002.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c83030002.filter,tp,0,LOCATION_MZONE,1,nil,tp)
		and Duel.IsExistingMatchingCard(c83030002.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c83030002.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
end
function c83030002.atop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c83030002.filter2,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return end
	local tc=Duel.GetFirstTarget()
	local g2=g:Select(tp,1,1,nil)
	local tc2=g2:GetFirst()
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.HintSelection(g2)
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc2,Group.FromCards(tc))
	end
end
function c83030002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c83030002.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c83030002.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
