--Carefree Teary
function c83030003.initial_effect(c)
	c:SetUniqueOnField(1,0,83030003)
	--Xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x833),3,2)
	c:EnableReviveLimit()
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c83030003.etg)
	e1:SetCondition(c83030003.econ)
	e1:SetValue(c83030003.efilter)
	c:RegisterEffect(e1)
	--Return to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(83030003,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,83030003)
	e2:SetCondition(c83030003.tdcon)
	e2:SetCost(c83030003.tdcost)
	e2:SetTarget(c83030003.tdtg)
	e2:SetOperation(c83030003.tdop)
	c:RegisterEffect(e2)
end
function c83030003.etg(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x833)
end
function c83030003.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
function c83030003.econ(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c83030003.cfilter(c)
	return c:IsFaceup() and c:IsCode(83030015)
end
function c83030003.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c83030003.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c83030003.costfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x833) and c:IsReleasable() and c:GetOwner()==tp
end
function c83030003.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and Duel.IsExistingMatchingCard(c83030003.costfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local g=Duel.SelectMatchingCard(tp,c83030003.costfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c83030003.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c83030003.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c83030003.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c83030003.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c83030003.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c83030003.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end
