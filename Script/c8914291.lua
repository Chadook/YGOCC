--Garbage Herculean Titan
function c8914291.initial_effect(c)
	c:SetUniqueOnField(1,0,8914291)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x71a) or (c:IsCode(18698739) or c:IsCode(44682448)),7,3)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8914291,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c8914291.target)
	e1:SetOperation(c8914291.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c8914291.reptg)
	e2:SetCondition(c8914291.rcon)
	c:RegisterEffect(e2)
end
function c8914291.filter(c)
	return c:IsType(TYPE_MONSTER) or c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function c8914291.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c8914291.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c8914291.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end 
	
end
function c8914291.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c8914291.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.Overlay(c,g)
	end
end
function c8914291.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(8914291,0)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function c8914291.rcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,8914290)
end