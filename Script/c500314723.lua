--Hayley, Maiden of Magnificent Vine
----Created by Chadook
--Scripted By Chadook
--Pfpfpfpfpfpfpfpffffpppt!
function c500314723.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x785c),5,3,c160009987.ovfilter,aux.Stringid(500314723,1),2,c500314723.xyzop)
	c:EnableReviveLimit()
--Let's get to the Point.
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c500314723.condition2)
	e4:SetCost(c500314723.cost2)
	e4:SetTarget(c500314723.target2)
	e4:SetOperation(c500314723.activate2)
	c:RegisterEffect(e4)
end
function c160009987.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x785c) and c:IsType(TYPE_XYZ) and c:GetRank()==4
end
function c500314723.xyzop(e,tp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(500314723,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end

function c500314723.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c500314723.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c500314723.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c500314723.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT,LOCATION_REMOVED)
	end
end